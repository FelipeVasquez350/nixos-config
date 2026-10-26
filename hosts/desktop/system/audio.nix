{ ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # The quantum is global per driver: an app asking for a tiny buffer (LMMS'
    # SDL backend defaults to 32 frames) reclocks the whole graph, which
    # Bluetooth A2DP and the EasyEffects chain cannot sustain -> xruns on every
    # stream. Floor it at 256 frames (~5.3ms @ 48kHz).
    extraConfig.pipewire."92-min-quantum" = {
      "context.properties"."default.clock.min-quantum" = 256;
    };

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
