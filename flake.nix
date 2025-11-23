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
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    openziti.url =
      "git+ssh://gitlab@gitlab.uranion.ai:2222/devops/nix-flakes/openziti.git?ref=main";
  };

  outputs = inputs@{ nixpkgs, sops-nix, home-manager, openziti, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {

        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/desktop
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs system; };
          modules = [
            # ./packages/dops.nix
            ./hosts/framework-13-laptop
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            openziti.nixosModules.ziti-edge-tunnel
          ];
        };
      };
    };
}
