{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay,
  opencode-release-info ? null,
  # Optional overlay configuration
  enableRust ? true,
  enableOpencode ? true,
  enableRaMultiplex ? true,
}:
# Import common overlays from lib/
# This now includes all overlays (rust, ra-multiplex, opencode, unstable)
import ../lib/overlays.nix {
  inherit
    nixpkgs-unstable
    ra-multiplex-src
    rust-overlay
    opencode-release-info
    ;
  inherit enableRust enableOpencode enableRaMultiplex;
}
