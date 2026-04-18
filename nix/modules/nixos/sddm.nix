{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable     = true;
    wayland.enable = true;
    theme      = "catppuccin-macchiato";
    package    = pkgs.kdePackages.sddm;
  };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor  = "macchiato";
      accent  = "mauve";
      font    = "IosevkaTerm Nerd Font";
      fontSize = "14";
    })
  ];
}
