{ pkgs, ... }: {
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
    telegram-desktop
    mattermost-desktop
    vorta
    protonvpn-gui
    wl-clipboard
    nushell
  ];
}
