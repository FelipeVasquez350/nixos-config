{
  inputs,
  config,
  pkgs,
  ...
}:
{

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";

    sessionVariables = {
      EDITOR = "vim"; # Change to your preferred editor
      VISUAL = "vim"; # Some programs check VISUAL before EDITOR
    };

    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
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

  # Ensure nix-direnv is available
  home.packages = with pkgs; [ nix-direnv ];
}
