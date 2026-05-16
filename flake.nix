{
  description = "My NixOS Configs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    vicinae.url = "github:vicinaehq/vicinae";

    openziti.url = "git+ssh://gitlab@gitlab.uranion.ai:2222/devops/nix-flakes/openziti.git?ref=main";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-wsl,
      nixpkgs-master,
      sops-nix,
      home-manager,
      openziti,
      pre-commit-hooks,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      master-pkgs = import nixpkgs-master { inherit system; };
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ nh ];
        shellHook = ''
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            ./hosts/desktop
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            openziti.nixosModules.ziti-edge-tunnel
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            ./hosts/framework-13-laptop
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            openziti.nixosModules.ziti-edge-tunnel
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs system; };
          modules = [
            ./hosts/wsl
            home-manager.nixosModules.home-manager
            nixos-wsl.nixosModules.default
          ];
        };
      };
    };
}
