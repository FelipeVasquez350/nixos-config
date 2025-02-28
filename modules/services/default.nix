{ config, pkgs, ... }: {
  imports = [
    ./syncthing.nix
  ];

  # Enable services
  services = {
    printing.enable = true;
    openssh.enable = true;
  };
}
