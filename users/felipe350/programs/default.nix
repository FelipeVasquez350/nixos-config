{ config, pkgs, ... }: {
  imports = [
    ./dev.nix
    ./media.nix
  ];

  home.packages = with pkgs; [
    bitwarden-desktop
    discord
    obsidian
    vorta
    zoom-us
    #syncthingtray
  ];
}
