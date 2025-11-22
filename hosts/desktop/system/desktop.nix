{ pkgs, ... }: {

  # XDG portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal ];
    config.common.default = "*";
  };

  # Enable the KDE Plasma Desktop Environment.
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      # Keyboard layout
      xkb = {
        layout = "it";
        variant = "";
      };
    };

    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

  };

  # Console keymap
  console.keyMap = "it2";
}
