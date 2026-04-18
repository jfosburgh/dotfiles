# Hyprland home-manager module: packages and config symlink.
#
# This file is used in two ways:
#   1. Via home-manager.sharedModules in nix/wm/hyprland.nix (NixOS)
#   2. Imported directly in flake.nix homeConfigurations (standalone home-manager)
#
# Note: waybar config lives at hypr/.config/waybar/ for now. When adding a second
# WM (e.g. niri), move it to waybar/.config/waybar/ and manage the symlink from
# desktop-common.nix instead.
{ config, pkgs, ... }:
let dot = "${config.home.homeDirectory}/dotfiles"; in
{
  home.packages = with pkgs; [
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    hyprsunset
    waybar
  ];

  xdg.configFile."hypr".source =
    config.lib.file.mkOutOfStoreSymlink "${dot}/hypr/.config/hypr";
}
