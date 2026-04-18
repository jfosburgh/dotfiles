# Combined Niri WM module (NixOS + home-manager).
#
# Import this in a host's default.nix to activate Niri on that machine.
# This replaces wm/hyprland.nix — changing that one import switches the WM.
#
# NixOS side: enables programs.niri and the required XDG portals.
# home-manager side: applies modules/home/wm/niri.nix to all users via sharedModules.
{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr    # wlroots-compatible portal (screencasting, screenshots)
      xdg-desktop-portal-gtk
    ];
    # Route Niri sessions through the wlr portal for screen sharing
    config.niri.default = [ "wlr" "gtk" ];
  };

  # home-manager: packages and niri/ symlink applied to all users on this host
  home-manager.sharedModules = [
    (import ../modules/home/wm/niri.nix)
  ];
}
