{
  description = "NixOS Configuration";

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
    opencode-release-info = {
      url = "https://api.github.com/repos/sst/opencode/releases/latest";
      flake = false;
    };
    zellij-fork = {
      url = "github:BSteffaniak/zellij/toggle-session";
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
      # Extract zellij fork metadata from flake.lock (PURE evaluation)
      lockData = builtins.fromJSON (builtins.readFile ./flake.lock);
      zellijLock = lockData.nodes.zellij-fork or { };
      zellijRev = zellijLock.locked.rev or "unknown";
      zellijRef = zellijLock.original.ref or "toggle-session";
      zellijNarHash = zellijLock.locked.narHash or "";
    in
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
              nixpkgs.config = {
                allowUnfree = true;
                android_sdk.accept_license = true;
              };
              nixpkgs.overlays = [
                inputs.nix-minecraft.overlay
              ]
              ++ (import ./overlays.nix {
                inherit nixpkgs-unstable;
                ra-multiplex-src = inputs.ra-multiplex;
                rust-overlay = inputs.rust-overlay;
                opencode-release-info = inputs.opencode-release-info;
                zellij-fork-src = inputs.zellij-fork;
                zellij-fork-rev = zellijRev;
                zellij-fork-ref = zellijRef;
                zellij-fork-narHash = zellijNarHash;
                # All overlays enabled by default for backward compatibility
                # Hosts can override by setting myConfig.overlays.* options
                enableRust = true;
                enableOpencode = true;
                enableRaMultiplex = true;
                enableZellijFork = true;
              });
            }
            (
              { config, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
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
