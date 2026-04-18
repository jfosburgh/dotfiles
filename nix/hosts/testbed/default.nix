# Host: testbed (KVM VM on Unraid, for testing)
# Profile: desktop
# WM: Hyprland
# Users: james
{ pkgs, inputs, ... }:
{
  imports = [
    ../../profiles/desktop.nix
    ../../wm/hyprland.nix    # ← change this single line to switch WMs
    ./hardware.nix
  ];

  networking.hostName = "testbed";

  # System users
  users.users.james = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [ "wheel" "input" "uinput" "audio" "video" "networkmanager" ];
  };

  # home-manager config
  home-manager.users.james = import ../../home/james.nix;
}
