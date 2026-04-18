{
  description = "James's NixOS + home-manager dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    helium.url      = "github:amaanq/helium-flake";
    mangowm.url     = "github:mangowm/mango";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, helium, mangowm, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs   = nixpkgs.legacyPackages.${system};
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self; };
      modules = [
        ./nix/hosts/${hostname}/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs        = true;
          home-manager.useUserPackages      = true;
          home-manager.extraSpecialArgs     = { inherit inputs; };
          home-manager.backupFileExtension  = "bak";
          # Per-host user lists are declared in hosts/<hostname>/default.nix
        }
      ];
    };
  in {
    nixosConfigurations = {
      sting     = mkHost "sting";
      glamdring = mkHost "glamdring";
      testbed   = mkHost "testbed";
    };

    # Standalone home-manager for non-NixOS systems.
    # WM module is included explicitly here since there's no NixOS sharedModules.
    homeConfigurations."james" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./nix/home/james.nix
        ./nix/modules/home/wm/hyprland.nix
      ];
    };
    homeConfigurations."resin" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./nix/home/resin.nix
        ./nix/modules/home/wm/hyprland.nix
      ];
    };
  };
}
