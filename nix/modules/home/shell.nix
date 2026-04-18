# Shell environment: zsh with Oh My Zsh, tmux with TPM, and shell integrations.
#
# Oh My Zsh is managed declaratively by programs.zsh — no setup/zsh/setup.sh needed.
# TPM is bootstrapped via home.activation on first switch.
#
# The envs, aliases, and functions dotfiles are sourced via initContent so they
# remain plain editable files in ~/dotfiles/zsh/.config/zsh/.
#
# Zsh dotfiles fate after migration:
#   zsh/.config/zsh/envs      — Active, sourced in initContent
#   zsh/.config/zsh/aliases   — Active, sourced in initContent
#   zsh/.config/zsh/functions — Active, sourced in initContent
#   zsh/.config/zsh/init      — No longer used (replaced by programs.zsh config)
#   zsh/.zshrc                — No longer used (home-manager generates ~/.zshrc)
{ config, pkgs, lib, ... }:
let dot = "${config.home.homeDirectory}/dotfiles"; in
{
  # Tmux: symlink config; bootstrap TPM on first activation
  home.packages = [ pkgs.tmux ];

  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dot}/tmux/.tmux.conf";

  home.activation.installTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      ${pkgs.git}/bin/git clone \
        https://github.com/tmux-plugins/tpm \
        "$HOME/.tmux/plugins/tpm"
    fi
  '';

  # Zsh: declarative Oh My Zsh; third-party plugins via nix packages
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable  = true;
      theme   = "robbyrussell";
      # archlinux plugin omitted — not available on NixOS
      plugins = [ "git" "sudo" "copyfile" "copybuffer" ];
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src  = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src  = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
    ];

    history = {
      size  = 10000;
      save  = 10000;
      share = true;
    };

    # Source the dotfiles directly — edits are immediately live without a rebuild
    initContent = ''
      source ${dot}/zsh/.config/zsh/envs
      source ${dot}/zsh/.config/zsh/aliases
      source ${dot}/zsh/.config/zsh/functions
    '';
  };

  # Shell integrations — each program adds its own init snippet to zshrc
  programs.starship = {
    enable              = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable              = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable              = true;
    enableZshIntegration = true;
  };
}
