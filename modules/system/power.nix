{ ... }: {
  services.tlp.enable = false;
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  services.power-profiles-daemon.enable = true;
}
