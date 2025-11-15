{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay,
  opencode-release-info ? null,
  zellij-fork-src ? null,
  zellij-fork-rev ? "unknown",
  zellij-fork-ref ? "custom",
  zellij-fork-narHash ? "",
  # Optional overlay configuration
  enableRust ? true,
  enableOpencode ? true,
  enableRaMultiplex ? true,
  enableZellijFork ? false,
}:
# Import common overlays from lib/
# This now includes all overlays (rust, ra-multiplex, opencode, unstable, zellij)
import ../lib/overlays.nix {
  inherit
    nixpkgs-unstable
    ra-multiplex-src
    rust-overlay
    opencode-release-info
    zellij-fork-src
    zellij-fork-rev
    zellij-fork-ref
    zellij-fork-narHash
    ;
  inherit
    enableRust
    enableOpencode
    enableRaMultiplex
    enableZellijFork
    ;
}
