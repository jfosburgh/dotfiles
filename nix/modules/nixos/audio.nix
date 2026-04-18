{ ... }:
{
  # Disable PulseAudio in favour of PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
    wireplumber.enable = true;
    camera.enable     = true;   # PipeWire camera support (screen sharing / webcam)
  };
}
