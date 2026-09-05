{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  datagripPkgs = import inputs.nixpkgs-datagrip {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  users.users.v = {
    isNormalUser = true;
    description = "v";
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

  environment.shells = [ pkgs.nushell ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/keys.txt";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "v"
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

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    # Optional: Add plugins like droidcam-obs if needed
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
  programs.extra-container.enable = true;

  # The Delta bundle ships its own libxkbcommon built for FHS, so it looks for
  # keymaps in /usr/share/X11 and segfaults when xkb_context_new returns NULL.
  # Point it at nixpkgs' data instead. Remove along with the nix-ld libs below.
  environment.sessionVariables = {
    XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
    XLOCALEDIR = "${pkgs.libx11}/share/X11/locale";
  };

  programs.nix-ld.enable = true;
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

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.gpu-screen-recorder.enable = true;
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;

  # Firewall ports for KDE Connect
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];

  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
        datagrip = datagripPkgs.jetbrains.datagrip;
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    # Programs
    bitwarden-desktop
    vesktop
    easyeffects
    obsidian
    telegram-desktop
    mattermost-desktop
    vorta
    proton-vpn
    flatpak
    kdePackages.kcalc
    llama-cpp-vulkan
    lmstudio
    vscode
    jujutsu
    jj-starship
    zed-editor
    claude-code
    opencode
    tmux
    nvd
    kdePackages.filelight

    # Utilities
    bat
    carapace
    curl
    fastfetch
    fzf
    ghostty
    gnome-disk-utility
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
    rustc
    rustup
    rustfmt
    rust-analyzer
    cargo

    dig
    direnv
    fd
    gcc
    github-desktop
    gh
    git
    glab
    gnumake
    jetbrains.datagrip
    jq
    neovim
    ripgrep
    OVMF # for UEFI support
    unetbootin # for creating bootable USB drives
    virtiofsd # for shared folders
    virt-manager
    virt-viewer
    wireshark

    # Gaming
    steam
    steamcmd
    heroic
    gamescope
    mangohud
    prismlauncher
    gpu-screen-recorder-gtk

    # Media
    # aseprite
    blender
    feishin
    # kid3
    # reco
    spotify
    vlc
    obs-studio
  ];
}
