{
  nixpkgs-unstable,
  ra-multiplex-src,
  rust-overlay,
  opencode-release-info ? null,
  zellij-fork ? null,
  cronstrue-src ? null,
}:
{
  # Build overlays with optional components
  # This function allows hosts to opt-out of specific overlays
  mkOverlays =
    {
      enableRust ? true,
      enableOpencode ? true,
      enableRaMultiplex ? true,
      enableZellijFork ? false,
      enableCronstrue ? false,
    }:
    let
      # Core overlays (always enabled)
      coreOverlays = [
        # Unstable packages overlay (core functionality)
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev) system;
            config.allowUnfree = true;
          };
        })
      ];

      # Optional overlays
      rustOverlays = if enableRust then (import ./rust-overlay.nix { inherit rust-overlay; }) else [ ];

      raMultiplexOverlays =
        if enableRaMultiplex then
          [
            (final: prev: {
              ra-multiplex-latest = final.rustPlatform.buildRustPackage {
                pname = "ra-multiplex";
                version = "unstable";

                src = ra-multiplex-src;

                cargoHash = "sha256-pwgNtxnO3oyX/w+tzRY5vAptw5JhpRhKCB2HYLEuA3A=";
              };
            })
          ]
        else
          [ ];

      zellijOverlays =
        if enableZellijFork && zellij-fork != null then
          (import ./zellij-overlay.nix { inherit zellij-fork; })
        else
          [ ];

      opencodeOverlays =
        if enableOpencode && opencode-release-info != null then
          (import ./opencode-overlay.nix { inherit opencode-release-info; })
        else
          [ ];

      cronstrueOverlays =
        if enableCronstrue && cronstrue-src != null then
          (import ./cronstrue-overlay.nix { inherit cronstrue-src; })
        else
          [ ];
    in
    coreOverlays
    ++ rustOverlays
    ++ raMultiplexOverlays
    ++ zellijOverlays
    ++ opencodeOverlays
    ++ cronstrueOverlays;
}
