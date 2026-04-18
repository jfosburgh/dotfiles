# CLI tools. Also manages the bin/ scripts symlink.
{ config, pkgs, ... }:
let dot = "${config.home.homeDirectory}/dotfiles"; in
{
  home.packages = with pkgs; [
    eza
    fd
    bat
    ripgrep
    fastfetch
    zip
    unzip
    gnutar
    wl-clipboard   # wl-copy / wl-paste
    upower         # battery-remaining script dependency
  ];

  # Bin scripts: out-of-store symlink so edits are immediately live
  home.file.".local/bin" = {
    source    = config.lib.file.mkOutOfStoreSymlink "${dot}/bin/.local/bin";
    recursive = true;
  };
}
