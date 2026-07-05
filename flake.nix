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
      url = "git+ssh://git@github.com/FelipeVasquez350/vm-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-nix-on-droid.url = "github:NixOS/nixpkgs/nixos-24.05";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-nix-on-droid";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  nixConfig = {
    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://cache.vm-registry.com/vm-registry"
      "https://nix-on-droid.cachix.org"
    ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "vm-registry:+3DJDFw+Bn19FVM920/fB4bNXkwt8L7tkTYG2m7ntAY="
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
            nixfmt-rfc-style.enable = true;
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nh
          deploy-rs
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
