# Host: sting (laptop)
# Profile: laptop (desktop + power management)
# WM: Hyprland
# Users: james, resin
{ pkgs, inputs, ... }:
{
  imports = [
    ../../profiles/laptop.nix
    ../../wm/hyprland.nix    # ← change this single line to switch WMs
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/tailscale.nix
    ./hardware.nix
  ];

  networking.hostName = "sting";
  system.stateVersion = "25.11";  # set to the NixOS version at first install — do not change

  # System users — add/remove users here to control who is on this machine
  users.users.james = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [ "wheel" "input" "uinput" "audio" "video" "networkmanager" ];
  };
  users.users.resin = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [ "wheel" "audio" "video" "networkmanager" ];
  };

  # home-manager configs for users present on this host
  home-manager.users.james = import ../../home/james.nix;
  home-manager.users.resin = import ../../home/resin.nix;
}
