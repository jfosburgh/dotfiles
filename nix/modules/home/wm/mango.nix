# MangoWM home-manager module: config symlink (and packages if the flake exports them).
# Applied to all users on a mango host via wm/mango.nix sharedModules,
# or imported directly in standalone homeConfigurations.
{ config, ... }:
let dot = "${config.home.homeDirectory}/dotfiles"; in
{
  xdg.configFile."mango".source =
    config.lib.file.mkOutOfStoreSymlink "${dot}/mango/.config/mango";
}
