{ inputs, config, pkgs, ... }: {

  imports = [ inputs.vicinae.homeManagerModules.default ];

  home = {
    username = "felipe350";
    homeDirectory = "/home/felipe350";
    file = {
      ".local/share/backgrounds" = {
        source = ./wallpapers;
        recursive = true;
      };
    };

    sessionVariables = {
      EDITOR = "vim"; # Change to your preferred editor
      VISUAL = "vim"; # Some programs check VISUAL before EDITOR
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/keys.txt";
    };

    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;

    config = {
      global = {
        hide_env_diff = true;
        warn_timeout = "30s";
        strict_env = false;
        silent = true;
      };
    };

    silent = true;
  };
  services.vicinae = {
    enable = true;
    autoStart = true;
    settings = {
      faviconService = "twenty"; # twenty | google | none
      font.size = 14;
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      theme.name = "vicinae-dark";
      window = {
        csd = true;
        opacity = 0.9;
        rounding = 10;
      };
    };
  };

  # Ensure nix-direnv is available
  home.packages = with pkgs; [ nix-direnv ];

  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    "org/gnome/desktop/background" = {
      picture-uri =
        "file://${config.home.homeDirectory}/.local/share/backgrounds/wallpaper.png";
      picture-uri-dark =
        "file://${config.home.homeDirectory}/.local/share/backgrounds/wallpaper.png";
      picture-options = "zoom";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "dev.zed.Zed.desktop"
        "zen-beta.desktop"
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Nautilus.desktop"
        "bitwarden.desktop"
        "discord.desktop"
        "github-desktop.desktop"
        "obsidian.desktop"
      ];
    };
  };
}
