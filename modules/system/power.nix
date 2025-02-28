{ config, pkgs, ... }: {
  services.tlp.enable = false;
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.power-profiles-daemon.enable = true;
}
