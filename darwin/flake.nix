{
  description = "Darwin (macOS) Configuration";

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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

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

    opencode-release-info = {
      url = "https://api.github.com/repos/sst/opencode/releases/latest";
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
              nixpkgs.config = {
                allowUnfree = true;
                android_sdk.accept_license = true;
              };
              nixpkgs.overlays = import ./overlays.nix {
                inherit nixpkgs-unstable;
                ra-multiplex-src = inputs.ra-multiplex;
                rust-overlay = inputs.rust-overlay;
                opencode-release-info = inputs.opencode-release-info;
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
                  backupFileExtension = "backup";
                  users.${username} = {
                    imports = [
                      ../home/darwin
                      ../hosts/macbook-air/home.nix
                    ];
                  };
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

        mac-studio = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin"; # Change to "x86_64-darwin" if Intel
          specialArgs = { inherit inputs; };
          modules = [
            ../hosts/mac-studio
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nixpkgs.config = {
                allowUnfree = true;
                android_sdk.accept_license = true;
              };
              nixpkgs.overlays = import ./overlays.nix {
                inherit nixpkgs-unstable;
                ra-multiplex-src = inputs.ra-multiplex;
                rust-overlay = inputs.rust-overlay;
                opencode-release-info = inputs.opencode-release-info;
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
                  backupFileExtension = "backup";
                  users.${username} = {
                    imports = [
                      ../home/darwin
                      ../hosts/mac-studio/home.nix
                    ];
                  };
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
