{ pkgs, ... }:
{
  home.packages = with pkgs; [
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "IosevkaTerm" "NerdFontsSymbolsOnly" ]; })
  ];

  fonts.fontconfig.enable = true;
}
