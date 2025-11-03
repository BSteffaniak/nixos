{
  description = "Braden's Darwin (macOS) Configuration";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Darwin-specific inputs
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    ra-multiplex = {
      url = "github:pr2502/ra-multiplex";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs-darwin,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      ...
    }:
    {

      # Darwin (macOS) Configurations
      darwinConfigurations = {
        macbook-air = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ../hosts/macbook-air
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nixpkgs.overlays = import ./overlays.nix {
                inherit nixpkgs-unstable;
                ra-multiplex-src = inputs.ra-multiplex;
              };
            }
            (
              { config, ... }:
              let
                username = config.myConfig.username;
              in
              {
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = username;
                  taps = {
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                  };
                  mutableTaps = false;
                };

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ../home/darwin;
                  extraSpecialArgs = {
                    inherit inputs;
                    osConfig = config;
                  };
                };

                homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
              }
            )
          ];
        };

        mac-mini = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin"; # Change to "x86_64-darwin" if Intel
          specialArgs = { inherit inputs; };
          modules = [
            ../hosts/mac-mini
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nixpkgs.overlays = import ./overlays.nix {
                inherit nixpkgs-unstable;
                ra-multiplex-src = inputs.ra-multiplex;
              };
            }
            (
              { config, ... }:
              let
                username = config.myConfig.username;
              in
              {
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = username;
                  taps = {
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                  };
                  mutableTaps = false;
                };

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ../home/darwin;
                  extraSpecialArgs = {
                    inherit inputs;
                    osConfig = config;
                  };
                };

                homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
              }
            )
          ];
        };
      };
    };
}
