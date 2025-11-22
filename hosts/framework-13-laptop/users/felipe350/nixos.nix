{ inputs, pkgs, ... }: {
  programs.zsh.enable = true;

  users.users.felipe350 = {
    isNormalUser = true;
    description = "felipe350";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "wireshark" ];

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
      trusted-users = [ "felipe350" "@wheel" ];
      min-free = 64000000;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [
    # Programs
    bitwarden-desktop
    discord
    obsidian
    telegram-desktop
    mattermost-desktop
    vorta
    protonvpn-gui

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
    nixfmt-classic
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
    spice-gtk
    tmux
    OVMF # for UEFI support
    unetbootin # for creating bootable USB drives
    virtiofsd # for shared folders
    virt-manager
    virt-viewer
    wireshark
    vscode
    zed-editor

    # Media
    aseprite
    blender
    feishin
    # kid3
    # reco
    spotify
    vlc
    obs-studio
    libreoffice

    # Flakes
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
