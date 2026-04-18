# Niri home-manager module: packages and config symlink.
# Applied to all users on a niri host via wm/niri.nix sharedModules,
# or imported directly in standalone homeConfigurations.
{ config, pkgs, ... }:
let dot = "${config.home.homeDirectory}/dotfiles"; in
{
  home.packages = with pkgs; [
    xwayland-satellite   # XWayland support for niri
    grim                 # screenshot capture
    slurp                # region selection (used with grim)
    waybar               # status bar
  ];

  xdg.configFile."niri".source =
    config.lib.file.mkOutOfStoreSymlink "${dot}/niri/.config/niri";
}
