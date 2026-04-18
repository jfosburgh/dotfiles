# home-manager config for the resin (work) user.
# Shares the common base (same dotfiles, shell, editor, etc.) but has a
# separate git identity, SSH key, and work-specific packages.
{ pkgs, lib, ... }:
{
  imports = [ ./common.nix ];

  home.username    = "resin";
  home.homeDirectory = "/home/resin";

  programs.git = {
    enable = true;
    settings = {
      user.name  = "James Fosburgh";
      user.email = "james@resin.co";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Work-specific packages — add VPN, work SDKs, etc. here
  home.packages = with pkgs; [
    slack
    s5cmd
    google-cloud-sdk
    obsidian
  ];

  home.activation.generateSshKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      ${pkgs.openssh}/bin/ssh-keygen \
        -t ed25519 \
        -C "james@resin.co" \
        -f "$HOME/.ssh/id_ed25519" \
        -N ""
    fi
  '';
}
