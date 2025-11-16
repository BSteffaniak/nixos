# Main overlay entry point
# Simplifies passing flake inputs to the automatic overlay discovery system
{
  lib,
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay ? null,
  opencode-release-info ? null,
  zellij-fork ? null,
  cronstrue-src ? null,
  lockFile ? ../flake.lock, # Each flake can override this
  # Optional overlay configuration
  enableRust ? true,
  enableOpencode ? true,
  enableRaMultiplex ? true,
  enableZellijFork ? false,
  enableCronstrue ? true,
}:
let
  # Bundle all inputs into a single attrset for easier passing
  inputs = {
    inherit
      nixpkgs-unstable
      rust-overlay
      opencode-release-info
      zellij-fork
      ;
    ra-multiplex = ra-multiplex-src;
    cronstrue = cronstrue-src;
  };

  # Helper to extract git input metadata from flake.lock
  mkGitInput = import ./mk-git-input.nix { inherit lockFile; };

  # Import all overlay functions (these must be imported here, not in mkOverlays.nix)
  overlayFunctions = {
    rust = import ./overlays/rust.nix;
    opencode = import ./overlays/opencode.nix;
    ra-multiplex = import ./overlays/ra-multiplex.nix;
    zellij = import ./overlays/zellij.nix;
    cronstrue = import ./overlays/cronstrue.nix;
  };

  mkOverlaysLib = import ./mkOverlays.nix {
    inherit
      lib
      inputs
      mkGitInput
      overlayFunctions
      ;
  };
in
mkOverlaysLib.mkOverlays {
  inherit
    enableRust
    enableOpencode
    enableRaMultiplex
    enableZellijFork
    enableCronstrue
    ;
}
