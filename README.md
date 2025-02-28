# nix

## Structure

```
.
├── flake.nix
|
├── assets/                  # Non-nix files like wallpapers, fonts, etc.
|
├── hosts/                    # Host-specific configurations
│   └── framework-13-laptop/
│       ├── default.nix      # Main system configuration for this host
│       └── hardware-configuration.nix
├── modules/                  # System-wide modules (affects all users)
│   ├── system/
│   │  ├── audio.nix
│   │  ├── default.nix
│   │  ├── desktop.nix
│   │  ├── network.nix
│   │  ├── power.nix
│   │  ├── virtualization.nix
│   └── services.nix          # System-wide services not directly necessary for the system
│       └── default.nix
└── users/                    # User-specific configurations
    └── felipe350/
        ├── home.nix         # Main home-manager configuration for this user
        ├── programs/        # User-specific program configurations
        │   ├── default.nix
        │   ├── git.nix
        │   └── ...
        └── services/        # User-specific services
            ├── default.nix
            └── ...
```


The flow is:
1. System-wide settings come from `modules/system/`
2. Host-specific settings come from `hosts/<hostname>/`
3. User-specific settings come from `users/<username>/`


My personal nix & NixOS configuration

To build the NixOS config run the following

```bash
# Update flake.lock
nix flake update

# Or replace only the specific input, such as home-manager:
nix flake update home-manager

# Test system changes
sudo nixos-rebuild test --flake .#laptop

# Test home-manager changes
home-manager build --flake .#felipe350@laptop

# Apply the updates
sudo nixos-rebuild switch --flake .#laptop

home-manager switch --flake .#felipe350@laptop

# Or to update flake.lock & apply with one command (i.e. same as running "nix flake update" before)
sudo nixos-rebuild switch --recreate-lock-file --flake .
```
