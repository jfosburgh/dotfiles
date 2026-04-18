# Combined MangoWM module (NixOS + home-manager).
#
# Import this in a host's default.nix to activate MangoWM on that machine.
# This replaces wm/hyprland.nix — changing that one import switches the WM.
#
# NOTE: verify the exact NixOS module API exported by the mangowm flake before
# first use: nix flake show github:mangowm/mango
{ inputs, ... }:
{
  # MangoWM NixOS module — enables the compositor system-wide
  imports = [ inputs.mangowm.nixosModules.default ];

  # home-manager: packages and mango/ symlink applied to all users on this host
  home-manager.sharedModules = [
    (import ../modules/home/wm/mango.nix)
  ];
}
