# Laptop NixOS profile: desktop + power management.
{ pkgs, ... }:
{
  imports = [
    ./desktop.nix
  ];

  # Power profile daemon (used by Hyprland bindings and system tray)
  services.power-profiles-daemon.enable = true;

  # Better power management
  powerManagement.enable = true;

  # Lid switch handling (suspend on close)
  services.logind.lidSwitch = "suspend-then-hibernate";

  # Backlight control (brightnessctl is in desktop-common home module)
  hardware.acpilight.enable = true;

  # Fingerprint reader
  services.fprintd.enable = true;
}
