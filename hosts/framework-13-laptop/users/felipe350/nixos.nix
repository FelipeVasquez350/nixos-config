{
  inputs,
  pkgs,
  ...
}:

let
  datagripPkgs = import inputs.nixpkgs-datagrip {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  programs.zsh.enable = true;

  users.users.felipe350 = {
    isNormalUser = true;
    description = "felipe350";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "vm-registry"
      "libvirtd"
      "wireshark"
    ];

    shell = pkgs.nushell;

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAqgfcNv5MLfj2+2f7UGB7yu4d7NwPNxxNdINwOATFGzW+w15yOimWneGbUKaAX+YV9fyebpX7CinsvEbHIyQVMw32e6CEW9lDtFtlTQLIYbKYglIDgaris1hZxkvYKUG3FgFYxDqG5yKVB9G3/uPBl8CAMAmYBPu2d+YGqmVw/NT31kWqfbBFyIsQq/PdxP1S0kx9ng1GfCVsfqTGJ9SNZIp2jTFHnIckp7hajJSDzucNVygfHApkQrA4jJ9RSzDZ/XWtlK3XFf0WE5qqsW6qhkJ47BI438vhYXz8y8b9X7qqGwoMIzY3Z+uS6/kVgvUXiHlslB8Xt1WzW2mFi7yH29gzThwqm5A/Noo6W7K++FBaMWZBkSO7naw02b/SRtyjeiiwkvsNv4+Iwyiwr/DCinz6IgngRvLEkOJcMCQ0Mert/VH8VK8AANqKrSmREQM8164gQHFyavOz7c2GGDOyWbIv9lWXjvjN5jxlFw8IErWMnqv/TqIo998yykeEGTE="
    ];
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/keys.txt";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "felipe350"
        "@wheel"
      ];
      min-free = 64000000;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.dconf.enable = true;
  programs.extra-container.enable = true;

  programs.nix-ld.enable = true; # needed to compile some packages like zed extensions

  # The Delta bundle ships its own libxkbcommon built for FHS, so it looks for
  # keymaps in /usr/share/X11 and segfaults when xkb_context_new returns NULL.
  # Point it at nixpkgs' data instead. Remove along with the nix-ld libs below.
  environment.sessionVariables = {
    XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
    XLOCALEDIR = "${pkgs.libx11}/share/X11/locale";
  };

  programs.nix-ld.libraries = with pkgs; [
    # Zed "Delta" beta: self-updating bundle in ~/.local/delta.app, so it runs
    # via nix-ld instead of being packaged. Remove once it ships a real flake.
    libglvnd
    libx11
    libxcb
    libxkbcommon
    vulkan-loader
    wayland
  ];

  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
        datagrip = prev.jetbrains.datagrip.overrideAttrs (_: {
          inherit (datagripPkgs.jetbrains.datagrip) version src;
        });
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    # Programs
    bitwarden-desktop
    discord
    obsidian
    telegram-desktop
    mattermost-desktop
    vorta
    proton-vpn
    opencode
    jujutsu
    jj-starship
    zed-editor
    claude-code
    opencode
    tmux
    nvd

    # Utilities
    bat
    btop
    carapace
    curl
    fastfetch
    fzf
    ghostty
    gnome-disk-utility
    gnomeExtensions.caffeine
    resources
    gnome-tweaks
    htop
    nmap
    nh
    nixd
    nixfmt
    nixos-anywhere
    nushell
    sops
    starship
    stow
    vim
    wget
    wl-clipboard
    zsh
    zoxide

    # Development
    rustup # for zed extensions
    # clang

    dig
    direnv
    fd
    gcc
    github-desktop
    gh
    git
    glab
    gnumake
    gsettings-desktop-schemas
    jetbrains.datagrip
    jq
    neovim
    ripgrep
    spice-gtk
    tmux
    OVMF # for UEFI support
    pika-backup
    mediawriter # for creating bootable USB drives
    virtiofsd # for shared folders
    virt-manager
    virt-viewer

    package-version-server

    # Media
    aseprite
    blender
    feishin
    kid3
    spotify
    vlc
    obs-studio
    libreoffice

    steam

    # Flakes
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
