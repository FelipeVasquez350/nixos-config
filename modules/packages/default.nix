{ pkgs, ... }:

{
  imports = [ ./flakes.nix ./utilities.nix ];

  environment.systemPackages = with pkgs; [ ghostty vim ];
}
