# Combined Hyprland WM module (NixOS + home-manager).
#
# Import this in a host's default.nix to activate Hyprland on that machine.
# Changing this single import to nix/wm/niri.nix (future) switches the WM.
#
# NixOS side: enables programs.hyprland and the required XDG portals.
# home-manager side: applies modules/home/wm/hyprland.nix to all users via sharedModules.
{ pkgs, ... }:
{
  # NixOS: Hyprland compositor and XDG portals
  programs.hyprland = {
    enable        = true;
    withUWSM      = true;   # UWSM session management (matches existing autostart.conf)
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    # Route Hyprland sessions through the Hyprland portal for screen sharing
    config.hyprland.default = [ "hyprland" "gtk" ];
  };

  # home-manager: packages and hypr/ symlink applied to all users on this host
  home-manager.sharedModules = [
    (import ../modules/home/wm/hyprland.nix)
  ];
}
