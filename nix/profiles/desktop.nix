# Desktop NixOS profile: base + audio, bluetooth, SDDM, XDG portals.
# Does NOT include any WM — import a nix/wm/ module in the host config to add one.
{ ... }:
{
  imports = [
    ./base.nix
    ../modules/nixos/audio.nix
    ../modules/nixos/bluetooth.nix
    ../modules/nixos/sddm.nix
  ];

  # XDG portal base (WM modules add their own extraPortals and per-compositor routing)
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    # Fallback for compositors without a specific entry; WM modules override this
    config.common.default = [ "gtk" ];
  };

  # Polkit for GUI authentication prompts
  security.polkit.enable = true;

  # Fonts
  fonts.fontconfig.enable = true;

  # Keyring (SSH keys, secrets)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
