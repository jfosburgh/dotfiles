# home-manager config for the james (personal) user.
{ pkgs, lib, ... }:
{
  imports = [ ./common.nix ];

  home.username    = "james";
  home.homeDirectory = "/home/james";

  programs.git = {
    enable = true;
    settings = {
      user.name  = "James Fosburgh";
      user.email = "jwfosburgh@gmail.com";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  home.packages = with pkgs; [
    hugo
    obsidian
    blender
    freecad
    prusa-slicer
    gimp
    prismlauncher
    localsend
    vintagestory
  ];

  services.syncthing.enable = true;

  home.activation.generateSshKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      ${pkgs.openssh}/bin/ssh-keygen \
        -t ed25519 \
        -C "jwfosburgh@gmail.com" \
        -f "$HOME/.ssh/id_ed25519" \
        -N ""
    fi
  '';

  home.activation.sshRemote = lib.hm.dag.entryAfter [ "generateSshKey" ] ''
    DOTFILES="$HOME/dotfiles"
    REMOTE=$(${pkgs.git}/bin/git -C "$DOTFILES" remote get-url origin 2>/dev/null)
    if [[ "$REMOTE" == https://* ]] && [ -f "$HOME/.ssh/id_ed25519" ]; then
      ${pkgs.git}/bin/git -C "$DOTFILES" remote set-url origin \
        git@github.com:jfosburgh/dotfiles.git
    fi
  '';
}
