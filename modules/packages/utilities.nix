{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    curl
    fastfetch
    fzf
    git
    resources
    gnome-tweaks
    htop
    nmap
    sops
    stow
    wget
    zoxide
  ];
}
