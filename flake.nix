{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    swww.url = "github:LGFae/swww";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit (prev) system;
                  config.allowUnfree = true;
                };

                # Add ra-multiplex from GitHub
                ra-multiplex-latest = final.rustPlatform.buildRustPackage {
                  pname = "ra-multiplex";
                  version = "unstable-2024-08-30";

                  src = final.fetchFromGitHub {
                    owner = "pr2502";
                    repo = "ra-multiplex";
                    rev = "master";
                    sha256 = "12x3rm9swnx21wllpbfwg5q4jvjr5ha6jn13dg2gjsbp0swbzqly";
                  };

                  cargoHash = "sha256-PnZh6wBMul3D4lsUQdn7arF2Qng2vdqtZHpPOtN59eU=";
                };
              })
            ];
          }
        ];
      };
    };
}
