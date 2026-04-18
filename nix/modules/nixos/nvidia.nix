# NVIDIA proprietary drivers. Import this module only on hosts with NVIDIA GPUs.
# GTX 1080 Ti requires the proprietary driver (open = false).
{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open               = false;
    nvidiaSettings     = true;
    package            = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
  };

  # Required for Wayland/Hyprland on NVIDIA
  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };
}
