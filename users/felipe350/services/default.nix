{ config, pkgs, ... }: {
  imports = [
    # TODO: Add system services here
  ];

  services = {
    syncthing = {
      tray = {
        enable = true;
        command = "syncthingtray";  # Add this line
      };
    };
  };
}
