{ ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.extraConfig."10-surround-downmix" = {
      "monitor.bluez.rules" = [
        {
          matches = [ { "node.name" = "~bluez_output.*"; } ];
          actions.update-props = {
            "channelmix.downmix" = true;
            "channelmix.mix-lfe" = true;
            "channelmix.normalize" = true;
            "channelmix.upmix" = false;
          };
        }
      ];
    };
  };
  services.pulseaudio.enable = false;
}
