{ config, pkgs, ... }: {
  imports = [
    ./syncthing.nix
  ];

  services = {
    printing.enable = true;
    openssh.enable = true;
  };
}
