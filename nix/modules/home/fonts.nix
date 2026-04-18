{ pkgs, ... }:
{
  home.packages = with pkgs; [
    noto-fonts-emoji
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig.enable = true;
}
