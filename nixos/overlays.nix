{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay,
  opencode-release-info ? null,
  zellij-fork ? null,
  cronstrue-src ? null,
  # Optional overlay configuration
  enableRust ? true,
  enableOpencode ? true,
  enableRaMultiplex ? true,
  enableZellijFork ? false,
  enableCronstrue ? false,
}:
# Import common overlays from lib/
# This now includes all overlays (rust, ra-multiplex, opencode, unstable, zellij, cronstrue)
import ../lib/overlays.nix {
  inherit
    nixpkgs-unstable
    ra-multiplex-src
    rust-overlay
    opencode-release-info
    zellij-fork
    cronstrue-src
    ;
  inherit
    enableRust
    enableOpencode
    enableRaMultiplex
    enableZellijFork
    enableCronstrue
    ;
}
