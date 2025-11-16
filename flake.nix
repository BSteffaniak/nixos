{
  description = "Cross-platform Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    ra-multiplex = {
      url = "github:pr2502/ra-multiplex";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode-release-info = {
      url = "https://api.github.com/repos/sst/opencode/releases/latest";
      flake = false;
    };
    zellij-fork = {
      url = "github:BSteffaniak/zellij/toggle-session";
      flake = false;
    };
    cronstrue = {
      url = "github:bradymholt/cronstrue";
      flake = false;
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
    let
      # Shared overlays for all configurations
      # All overlays enabled by default for backward compatibility
      overlays = import ./lib/overlays.nix {
        inherit (nixpkgs) lib;
        inherit nixpkgs-unstable;
        ra-multiplex-src = inputs.ra-multiplex;
        rust-overlay = inputs.rust-overlay;
        opencode-release-info = inputs.opencode-release-info;
        zellij-fork = inputs.zellij-fork;
        cronstrue-src = inputs.cronstrue;
        # Hosts can override these by creating their own overlay list
        enableRust = true;
        enableOpencode = true;
        enableRaMultiplex = true;
        enableZellijFork = true;
        enableCronstrue = true;
      };
    in
    {
      # Standalone home-manager configurations (for Ubuntu, etc.)
      homeConfigurations = {
        "braden@ubuntu-laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = overlays;
          };
          modules = [
            ./hosts/ubuntu-laptop/home.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };

      # You can add more standalone configurations here for other machines
      # "braden@work-laptop" = ...;
      # "braden@other-machine" = ...;
    };
}
