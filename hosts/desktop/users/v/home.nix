{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  home = {
    username = "v";
    homeDirectory = "/home/v";
    file = {
      ".local/share/backgrounds" = {
        source = ./wallpapers;
        recursive = true;
      };
      ".config/autostart/ssh-add.desktop".text = ''
        [Entry]
        Type=Application
        Name=Load SSH Keys
        Exec=sh -c 'find ~/.ssh/ -type f -name "id_*" ! -name "*.pub" -exec ssh-add {} +'
        X-KDE-AutostartScript=true
      '';
    };

    sessionVariables = {
      EDITOR = "vim"; # Change to your preferred editor
      VISUAL = "vim"; # Some programs check VISUAL before EDITOR
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/keys.txt";
    };

    stateVersion = "25.05";
  };

  programs.plasma = {
    enable = true;
    workspace = {
      wallpaper = "${config.home.homeDirectory}/.local/share/backgrounds/wallpaper.png";
    };
    # https://github.com/nix-community/plasma-manager/pull/308/files#diff-9ad67fb09adfdee1b6e1435ea3bb616e446522d086db5c1f84ead8bf911a62bf
    configFile.kwinrc.Effect-overview.BorderActivate = 3;
    # panels = [{
    #   widgets = [{
    #     iconTasks = {
    #       launchers = [
    #         "applications:org.kde.dolphin.desktop"
    #         "applications:org.kde.konsole.desktop"
    #         # settings systemmonitr, dolphin, zen, zed, ghostty, obsidian, github,desktop,discord

    #         # at /home/v/.config/plasma-org.kde.plasma.desktop-appletsrc
    #         # launchers=applications:systemsettings.desktop,file:///nix/store/g9gkgi5jg1v4059cnnpa78vb21zr9nkq-system-path/share/applications/org.kde.plasma-systemmonitor.desktop,preferred://filemanager,preferred://browser,applications:dev.zed.Zed.desktop,applications:com.mitchellh.ghostty.desktop,file:///nix/store/g9gkgi5jg1v4059cnnpa78vb21zr9nkq-system-path/share/applications/obsidian.desktop,file:///nix/store/g9gkgi5jg1v4059cnnpa78vb21zr9nkq-system-path/share/applications/github-desktop.desktop,applications:discord.desktop
    #       ];
    #     };
    #   }];
    # }];
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
  home.packages = with pkgs; [ nix-direnv ];
}
