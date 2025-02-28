{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "felipe350";
    dataDir = "/home/felipe350/Documents";
    configDir = "/home/felipe350/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
  };
}
