{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, ... }: {
    nixosConfigurations = {
      laptop = let
        username = "felipe350";
        system = "x86_64-linux";
        specialArgs = {inherit inputs username;};
      in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/framework-13-laptop
            ./modules/system
            ./modules/services
            ./modules/packages
            ./users/${username}/nixos.nix

            # Add this diagnostic module
            ({ lib, ... }: {
              system.activationScripts.debug-home-manager = ''
                echo "Debug: Home Manager Import Status"
                echo "Home Manager module path: ${toString home-manager.nixosModules.home-manager}"
                echo "User home.nix path: ${toString ./users/${username}/home.nix}"
                echo "User exists: ${toString (builtins.pathExists ./users/${username}/home.nix)}"
              '';
            })

            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${username} = import ./users/${username}/home.nix;
              };
            }
          ];
        };
    };
  };
}
