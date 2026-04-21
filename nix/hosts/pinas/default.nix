# Host: pinas (Raspberry Pi 3 NAS)
# Headless aarch64 backup storage server — 2× 6TB HDDs as single LVM volume
# Users: james (wheel, SSH key auth only)
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos/tailscale.nix
    ./hardware.nix
  ];

  # Pi3 uses extlinux, not EFI/GRUB
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "pinas";

  # systemd-networkd is much lighter than NetworkManager — appropriate for a
  # headless wired server. Handles DHCP on the ethernet interface.
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks."10-wired" = {
    matchConfig.Name  = "eth*";
    networkConfig.DHCP = "yes";
  };

  # zram swap: compresses RAM contents rather than hitting disk.
  # On a 1 GB system this is the single biggest quality-of-life improvement.
  zramSwap.enable = true;

  # Kill runaway processes gracefully before the kernel OOM killer bricks the box.
  systemd.oomd.enable = true;

  time.timeZone      = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # SSH — key auth only, no passwords
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin        = "no";
    };
  };

  # 2× 6TB drives as a single 12TB LVM linear volume mounted at /data.
  # One-time setup before first nixos-rebuild (run on the Pi as root):
  #   wipefs -a /dev/sda && wipefs -a /dev/sdb   # clear existing partition tables
  #   pvcreate /dev/sda /dev/sdb
  #   vgcreate data-vg /dev/sda /dev/sdb
  #   lvcreate -l 100%FREE -n data-lv data-vg
  #   mkfs.ext4 /dev/data-vg/data-lv
  fileSystems."/data" = {
    device  = "/dev/data-vg/data-lv";
    fsType  = "ext4";
    options = [ "defaults" "nofail" ];
  };

  # Samba share — accessible over tailscale only, not the local network.
  # After nixos-rebuild, set the samba password once: sudo smbpasswd -a james
  services.samba = {
    enable      = true;
    nmbd.enable = false;  # NetBIOS name resolution — not needed, using tailscale DNS
    openFirewall = true;
    settings = {
      global = {
        "server string" = "pinas";
        "server role"   = "standalone server";
      };
      backups = {
        path         = "/data/backups";
        browseable   = "yes";
        "read only"  = "no";
        "guest ok"   = "no";
        "valid users" = "james";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  # Create the backups directory on first boot if it doesn't exist
  systemd.tmpfiles.rules = [ "d /data/backups 0775 james users -" ];

  # Backup tools
  environment.systemPackages = with pkgs; [
    git
    vim
    rsync
    restic
  ];

  users.users.james = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];
    # Populate with your SSH public key(s):
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    trusted-users          = [ "root" "james" ];
  };

  # Keep the journal small — not much disk headroom to waste on logs.
  services.journald.extraConfig = "SystemMaxUse=50M";

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };

  system.stateVersion = "25.11";  # set to the NixOS version at first install — do not change
}
