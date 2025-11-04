{
  description = "Braden's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    swww.url = "github:LGFae/swww";
    ra-multiplex = {
      url = "github:pr2502/ra-multiplex";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    {

      # NixOS Configurations
      nixosConfigurations = {
        nixos-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ../hosts/nixos-desktop
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                inputs.nix-minecraft.overlay
              ]
              ++ (import ./overlays.nix {
                inherit nixpkgs-unstable;
                ra-multiplex-src = inputs.ra-multiplex;
                rust-overlay = inputs.rust-overlay;
              });
            }
            (
              { config, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.braden = {
                    imports = [
                      ../home/nixos # Generic base config
                      ../hosts/nixos-desktop/home.nix # Personal overrides
                    ];
                  };
                  extraSpecialArgs = {
                    inherit inputs;
                    osConfig = config; # Pass system config to home-manager
                  };
                };
              }
            )
          ];
        };
      };
    };
}
