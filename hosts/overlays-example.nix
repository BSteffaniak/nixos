# Example overlay configuration for hosts
# Copy this file to your host directory (e.g., hosts/nixos-desktop/overlays.nix)
# and customize the flags to disable overlays you don't need.
#
# Then in your host's flake, import this file instead of the default overlay configuration.

{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay,
  opencode-release-info ? null,
}:

# Example 1: Disable Rust overlay (saves build time if you don't use Rust)
import ../../lib/overlays.nix {
  inherit
    nixpkgs-unstable
    ra-multiplex-src
    rust-overlay
    opencode-release-info
    ;
  enableRust = false;
  enableOpencode = true;
  enableRaMultiplex = true;
}

# Example 2: Only enable unstable packages (minimal setup)
# import ../../lib/overlays.nix {
#   inherit nixpkgs-unstable ra-multiplex-src rust-overlay opencode-release-info;
#   enableRust = false;
#   enableOpencode = false;
#   enableRaMultiplex = false;
# }

# Example 3: Enable everything (default behavior)
# import ../../lib/overlays.nix {
#   inherit nixpkgs-unstable ra-multiplex-src rust-overlay opencode-release-info;
#   enableRust = true;
#   enableOpencode = true;
#   enableRaMultiplex = true;
# }
