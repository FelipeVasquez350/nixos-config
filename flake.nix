{
  description = "My NixOS Configs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    vm-registry = {
      url = "git+ssh://git@github.com/vm-registry/vm-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-nix-on-droid.url = "github:NixOS/nixpkgs/nixos-24.05";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-nix-on-droid";
    };

    deploy-rs.url = "github:serokell/deploy-rs";

    # jetbrains.rider pinned to 2025.2.4 — last release covered by the perpetual
    # fallback licence (All Products Pack fallback ver. 2025.2)
    nixpkgs-rider.url = "github:nixos/nixpkgs/27b24b710cef878aec776e355aee5f359ed274d6";
    nixpkgs-datagrip.url = "github:nixos/nixpkgs/a683adc19ff5228af548c6539dbc3440509bfed3";
    # Packages the private Delta Linux release tarballs. Fetching them needs a
    # GitHub token (see the flake's README) or a pre-seeded store path.
    delta-nix = {
      url = "git+ssh://git@github.com/zed-industries/delta-nix-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://cache.vm-registry.com"
      "https://nix-on-droid.cachix.org"
    ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "cache.vm-registry.com-1:tSrq9hr+OuXyBEO0V0FHzgMhfaMPVpcSR4CN4177Zis="
      "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
    ];
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-wsl,
      sops-nix,
      home-manager,
      openziti,
      pre-commit-hooks,
      vm-registry,
      nixpkgs-nix-on-droid,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      activateNixOnDroid =
        configuration:
        inputs.deploy-rs.lib.aarch64-linux.activate.custom configuration.activationPackage "${configuration.activationPackage}/activate";
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.nh
          pkgs.deploy-rs
        ];

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
            vm-registry.nixosModules.default
            {
              nixpkgs.config.permittedInsecurePackages = [
                "electron-39.8.10"
              ];

              environment.systemPackages = [
                inputs.vm-registry.packages.${system}.vm-registry-cli
                inputs.vm-registry.packages.${system}.vm-registry-desktop
                inputs.vm-registry.packages.${system}.vm-registry-lsp
              ];

              services.vm-registry-daemon.enable = true;
            }
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            ./hosts/framework-13-laptop
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            openziti.nixosModules.ziti-edge-tunnel
            vm-registry.nixosModules.default
            {
              nixpkgs.config.permittedInsecurePackages = [
                "electron-39.8.10"
              ];

              environment.systemPackages = [
                inputs.vm-registry.packages.${system}.vm-registry-cli
                inputs.vm-registry.packages.${system}.vm-registry-desktop
                inputs.vm-registry.packages.${system}.vm-registry-lsp
                pkgs.cdrkit
                pkgs.qemu_kvm
              ];

              services.vm-registry-daemon.enable = true;
              systemd.services.vm-registry-daemon.path = [
                pkgs.cdrkit
                pkgs.qemu_kvm
              ];
            }
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

      nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs-nix-on-droid { system = "aarch64-linux"; };
        modules = [ ./hosts/nix-on-droid ];
      };

      deploy.nodes."android" = {
        hostname = "nothingphone1";
        profiles.system = {
          sshUser = "nix-on-droid";
          user = "nix-on-droid";
          magicRollback = true;
          sshOpts = [
            "-p"
            "8022"
          ];
          path = activateNixOnDroid self.nixOnDroidConfigurations.default;
        };
      };
    };
}
