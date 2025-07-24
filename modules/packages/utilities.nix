{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    curl
    fastfetch
    fzf
    git
    gnome-resources
    gnome-tweaks
    htop
    nmap
    sops
    stow
    wget
    zoxide

  ];
}
