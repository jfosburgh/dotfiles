# Host: glamdring (desktop, NVIDIA GTX 1080 Ti)
# Profile: desktop
# WM: Hyprland
# Extra: NVIDIA proprietary drivers, kanata
# Users: james (add resin here if desired)
{ pkgs, inputs, ... }:
{
  imports = [
    ../../profiles/desktop.nix
    ../../wm/hyprland.nix            # ← change this single line to switch WMs
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/kanata.nix
    ./hardware.nix
  ];

  networking.hostName = "glamdring";

  # System users
  users.users.james = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [ "wheel" "input" "uinput" "audio" "video" "networkmanager" ];
  };

  # home-manager configs
  home-manager.users.james = import ../../home/james.nix;
}
