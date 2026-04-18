# Keyboard remapper. Replaces setup/kanata/setup.sh — NixOS handles
# udev rules and group membership automatically.
{ self, ... }:
{
  services.kanata = {
    enable   = true;
    keyboards.default.configFile =
      "${self}/kanata/.config/kanata/kanata.kbd";
  };
}
