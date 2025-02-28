{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gnome
  ];
}
