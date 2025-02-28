{ lib, pkgs, config, ...}: {
  imports = [
    ./programs/default.nix
    ./services
  ];

  home = {
    username = "felipe350";
    homeDirectory = "/home/felipe350";
    file = {
      ".local/share/backgrounds" = {
        source = ./wallpapers;
        recursive = true;
      };
    };

    stateVersion = "24.11";
  };

  # Make sure this is enabled
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/.local/share/backgrounds/wallpaper.png";
      picture-uri-dark = "file://${config.home.homeDirectory}/.local/share/backgrounds/wallpaper.png";
      picture-options = "zoom";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "dev.zed.Zed.desktop"
        "zen.desktop"
        "com.mitchellh.ghostty.desktop"
        "code.desktop"
        "org.gnome.Nautilus.desktop"
        "bitwarden.desktop"
        "discord.desktop"
        "github-desktop.desktop"
        "obsidian.desktop"
      ];
    };
  };
}
