{ config, pkgs, ... }: {
  # XDG portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # GNOME Desktop configuration
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Keyboard layout
    xkb = {
      layout = "it";
      variant = "";
    };
  };

  # Console keymap
  console.keyMap = "it2";
}
