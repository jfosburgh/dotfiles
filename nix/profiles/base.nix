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
  ];

  # Allow unfree packages (required for NVIDIA, etc.)
  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };
}
