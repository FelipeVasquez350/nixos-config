{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, sops-nix, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "felipe350";
    in {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };

          modules = [
            ./hosts/framework-13-laptop
            ./modules/system
            ./modules/services
            ./modules/packages
            ./users/${username}/nixos.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs username; };
                users.${username} = import ./users/${username}/home.nix;
              };
            }
          ];
        };
      };

      devShells."${system}" = {
        default = pkgs.mkShell {
          buildInputs = [ pkgs.pnpm pkgs.openssl pkgs.fnm ];

          shellHook = ''
            export NIX_LD_LIBRARY_PATH=${
              pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.openssl ]
            }
            export NIX_LD=${
              pkgs.lib.fileContents
              "${pkgs.stdenv.cc}/nix-support/dynamic-linker"
            }
            
            # Initialize fnm
            eval "$(fnm env --use-on-cd)"
            
            # Ensure fnm-managed Node.js takes precedence in PATH
            export PATH="$HOME/.fnm/current/bin:$PATH"
          '';
        };
      };
    };
}
