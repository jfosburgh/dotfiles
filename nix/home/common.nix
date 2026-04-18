# Shared home-manager base imported by all users.
# Does NOT include a WM module — WM is selected at the host level via
# home-manager.sharedModules (NixOS) or explicitly in flake.nix (standalone).
{ ... }:
{
  imports = [
    ../modules/home/cli.nix
    ../modules/home/desktop-common.nix
    ../modules/home/dev.nix
    ../modules/home/fonts.nix
    ../modules/home/shell.nix
  ];

  home.stateVersion = "25.05";
}
