# NixOS Configuration

My personal NixOS and home-manager configuration.

## Structure

```
.
├── hosts/
│   └── <machine>/
│       ├── services/
│       ├── system/
│       ├── users/<name>/
│       │   ├── home.nix
│       │   ├── nixos.nix
│       │   └── secrets.yaml
│       ├── wallpapers/
│       ├── default.nix
│       └── hardware-configuration.nix
│
├── packages/
|
├── .gitignore
├── .sops.yaml
├── flake.lock
├── flake.nix
└── README.md
```

## Configuration Flow


## Building

### Update flake inputs

```bash
nix flake update
nix flake update home-manager
```

### Test changes

```bash
nh os switch --dry .#nixosConfigurations.laptop

```

### Apply changes

```bash
nh os switch --ask .#nixosConfigurations.laptop
```
