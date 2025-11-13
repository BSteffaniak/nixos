{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay ? null,
  opencode-release-info ? null,
  # Optional overlay configuration
  enableRust ? true,
  enableOpencode ? true,
  enableRaMultiplex ? true,
}:
let
  mkOverlaysLib = import ./mkOverlays.nix {
    inherit
      nixpkgs-unstable
      ra-multiplex-src
      rust-overlay
      opencode-release-info
      ;
  };
in
mkOverlaysLib.mkOverlays {
  inherit enableRust enableOpencode enableRaMultiplex;
}
