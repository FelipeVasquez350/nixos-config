{ # config
pkgs, ... }: {
  imports = [
    ./dev.nix
    ./media.nix
    #./tex.nix
  ];

  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    discord
    obsidian
    vorta
    zoom-us
    protonvpn-gui
  ];
}
