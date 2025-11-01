{ ... }: {
  services = {
    printing.enable = true;

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        AllowUsers = null;
        UseDns = true;
        X11Forwarding = false;
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    syncthing = {
      enable = true;
      user = "felipe350";
      dataDir = "/home/felipe350/Documents";
      configDir = "/home/felipe350/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      openDefaultPorts = true;
    };

    resolved.enable = true;
  };
}
