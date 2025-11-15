{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay ? null,
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
let
  mkOverlaysLib = import ./mkOverlays.nix {
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
  };
in
mkOverlaysLib.mkOverlays {
  inherit
    enableRust
    enableOpencode
    enableRaMultiplex
    enableZellijFork
    ;
}
