# Base NixOS profile: networking, locale, core system settings.
# All other profiles import this one.
{ pkgs, ... }:
{
  imports = [
    ../modules/nixos/networking.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Locale and timezone
  time.timeZone      = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  # Core system packages available to all users
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    home-manager
  ];

  # Zsh must be enabled at the system level for users.users.*.shell = pkgs.zsh to work
  programs.zsh.enable = true;

  # Allow unfree packages (required for NVIDIA, etc.)
  nixpkgs.config.allowUnfree = true;

  # Allow building for aarch64 (e.g. pinas) on x86_64 via QEMU emulation.
  # Required for: nixos-rebuild switch --flake .#pinas --build-host localhost --target-host james@pinas --use-remote-sudo
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    extra-platforms       = [ "aarch64-linux" ];
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };
}
