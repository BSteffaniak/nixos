{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay ? null,
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
let
  mkOverlaysLib = import ./mkOverlays.nix {
    inherit
      nixpkgs-unstable
      ra-multiplex-src
      rust-overlay
      opencode-release-info
      zellij-fork
      cronstrue-src
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
