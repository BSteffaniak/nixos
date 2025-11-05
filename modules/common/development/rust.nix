{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.rust;

  # Determine which Rust packages to include based on configuration
  rustPackages =
    let
      hasStable = cfg.includeStable;
      hasNightly = cfg.includeNightly;

      # Base cargo utilities
      cargoUtils =
        with pkgs;
        [
          cargo-binstall
          cargo-nextest
          cargo-lambda
        ]
        ++ (optional cfg.includeRaMultiplex ra-multiplex-latest);

      # Rust toolchain packages based on configuration
      rustToolchains =
        if hasStable && hasNightly then
          # Both stable and nightly: use wrappers
          with pkgs;
          [
            cargo-wrapped
            rustc-wrapped
            rustStable # Keep stable for rust-analyzer
          ]
        else if hasStable then
          # Stable only: use direct packages
          with pkgs;
          [
            rustStable
          ]
        else if hasNightly then
          # Nightly only: use direct packages
          with pkgs;
          [
            rustNightly
          ]
        else
          # Neither enabled: empty list
          [ ];
    in
    rustToolchains ++ cargoUtils;
in
{
  options.myConfig.development.rust = {
    enable = mkEnableOption "Rust development environment";

    includeStable = mkOption {
      type = types.bool;
      default = true;
      description = "Include Rust stable toolchain";
    };

    includeNightly = mkOption {
      type = types.bool;
      default = false;
      description = "Include Rust nightly toolchain";
    };

    includeRaMultiplex = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Include ra-multiplex (rust-analyzer multiplexer).
        Useful for managing multiple rust-analyzer instances in monorepos.
        Set to false if you don't need this tool.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = rustPackages;

    # Warn if neither stable nor nightly is enabled
    warnings = optional (
      !cfg.includeStable && !cfg.includeNightly
    ) "Rust development environment is enabled but neither stable nor nightly toolchain is included.";
  };
}
