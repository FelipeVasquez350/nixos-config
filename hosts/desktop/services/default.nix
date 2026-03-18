{ ... }:
{
  imports = [ ./cloudflared.nix ];

  services = {
    flatpak.enable = true;

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
      user = "v";
      dataDir = "/home/v/Documents";
      configDir = "/home/v/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      openDefaultPorts = true;
    };

    ziti-edge-tunnel = {
      enable = true;
    };
  };
}
