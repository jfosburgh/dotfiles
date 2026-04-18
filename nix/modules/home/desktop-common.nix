# WM-agnostic desktop packages and config symlinks.
# Works with any Wayland compositor — does NOT include WM-specific tools.
# WM packages and their config symlinks live in modules/home/wm/.
{ config, pkgs, inputs, ... }:
let
  dot    = "${config.home.homeDirectory}/dotfiles";
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with pkgs; [
    # Browsers
    inputs.zen-browser.packages.${system}.default
    inputs.helium.packages.${system}.default
    chromium

    # Apps
    nautilus
    vlc
    nwg-look
    loupe             # image viewer
    btop
    satty             # screenshot annotation

    # Terminal
    ghostty

    # Notifications + OSD
    mako
    swayosd

    # Launcher
    rofi

    # Media / system utilities
    wiremix           # TUI PipeWire mixer
    polkit_gnome
    pamixer
    brightnessctl
    playerctl
    libnotify         # notify-send

    # Dev/misc
    opencode
  ];

  services.swayosd.enable = true;

  xdg.configFile = {
    "ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dot}/ghostty/.config/ghostty";
    "mako".source    = config.lib.file.mkOutOfStoreSymlink "${dot}/mako/.config/mako";
    "rofi".source    = config.lib.file.mkOutOfStoreSymlink "${dot}/rofi/.config/rofi";
    "qt5ct".source   = config.lib.file.mkOutOfStoreSymlink "${dot}/theme/.config/qt5ct";
    "qt6ct".source   = config.lib.file.mkOutOfStoreSymlink "${dot}/theme/.config/qt6ct";
  };
}
