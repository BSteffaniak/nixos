{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay,
  opencode-release-info,
}:
# Import shared Rust overlay from lib/
(import ../lib/rust-overlay.nix { inherit rust-overlay; })
# Import common overlays from lib/
++ (import ../lib/overlays.nix { inherit nixpkgs-unstable ra-multiplex-src opencode-release-info; })
