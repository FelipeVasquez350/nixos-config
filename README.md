# NixOS Configuration

My personal NixOS and home-manager configuration.

## Structure

```
.
├── flake.nix
├── flake.lock
│
├── hosts/
│   └── framework-13-laptop/
│       ├── default.nix
│       └── hardware-configuration.nix
│
├── modules/
│   ├── packages/
│   ├── services/
│   └── system/
│
└── users/
    └── felipe350/
        ├── home.nix
        ├── nixos.nix
        ├── packages/
        ├── programs/
        ├── services/
        ├── secrets.yaml
        └── wallpapers/
```

## Configuration Flow

1. System-wide settings come from `modules/system/`
2. System-wide packages come from `modules/packages/`
3. Host-specific settings come from `hosts/<hostname>/`
4. User-specific settings come from `users/<username>/`

## Building

### Update flake inputs

```bash
nix flake update
nix flake update home-manager
```

### Test changes

```bash
sudo nixos-rebuild test --flake .#laptop
home-manager build --flake .#felipe350@laptop
```

### Apply changes

```bash
sudo nixos-rebuild switch --flake .#laptop
home-manager switch --flake .#felipe350@laptop
```

### Update and apply in one command

```bash
sudo nixos-rebuild switch --recreate-lock-file --flake .
home-manager switch --flake .#felipe350@laptop
```
