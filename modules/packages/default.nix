{ config, pkgs, inputs, ... }:

{
  imports = [
    ./dependencies.nix
    ./flakes.nix
    ./utilities.nix
  ];

  environment.systemPackages = with pkgs; [
    ghostty
    vim
  ];
}
