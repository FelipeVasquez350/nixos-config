{
  inputs,
  pkgs,
  lib,
  ...
}:
{

  users.users.v = {
    isNormalUser = true;
    description = "v";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
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

  programs.nix-ld.enable = true;
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

  programs.nix-ld.libraries = with pkgs; [ icu ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;

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

  environment.systemPackages = with pkgs; [
    # Programs
    bitwarden-desktop
    discord
    discord-canary
    obsidian
    telegram-desktop
    mattermost-desktop
    vorta
    protonvpn-gui
    flatpak
    kdePackages.kcalc
    llama-cpp-vulkan
    vscode
    jujutsu
    zed-editor

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

    # Media
    # aseprite
    # blender
    feishin
    # kid3
    # reco
    spotify
    vlc
    obs-studio

    # Flakes
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
