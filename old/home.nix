{ config, pkgs, ... }:

let
  dotfilesRepo = "/home/felipe350/dotfiles";

  modifiedZedConfig = pkgs.runCommand "zed-settings.json" {} ''
    cp ${dotfilesRepo}/.config/zed/settings.json $out
    ${pkgs.jq}/bin/jq '.buffer_font_size = 20 | .ui_font_size = 20' $out > tmp
    mv tmp $out
  '';
in
{
  home.activation = {
    stowDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
      cd ${dotfilesRepo}
      ${pkgs.stow}/bin/stow --target=$HOME --ignore='.config/zed/settings.json' .
    '';

    zedConfig = lib.hm.dag.entryAfter ["stowDotfiles"] ''
      mkdir -p $HOME/.config/zed
      cp ${modifiedZedConfig} $HOME/.config/zed/settings.json
    '';
  };
}
