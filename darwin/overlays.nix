{
  lib,
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay,
  opencode-release-info ? null,
  cronstrue-src ? null,
  # Optional overlay configuration
  enableRust ? true,
  enableOpencode ? true,
  enableRaMultiplex ? true,
  enableCronstrue ? true,
}:
# Import common overlays from lib/
# This now includes all overlays (rust, ra-multiplex, opencode, unstable, cronstrue)
import ../lib/overlays.nix {
  inherit
    lib
    nixpkgs-unstable
    ra-multiplex-src
    rust-overlay
    opencode-release-info
    cronstrue-src
    ;
  lockFile = ./flake.lock;
  inherit
    enableRust
    enableOpencode
    enableRaMultiplex
    enableCronstrue
    ;
}
