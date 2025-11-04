{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.rust = {
    enable = mkEnableOption "Rust development environment";
  };

  config = mkIf config.myConfig.development.rust.enable {
    environment.systemPackages = with pkgs; [
      # Wrapped cargo and rustc with +nightly/+stable support
      cargo-wrapped
      rustc-wrapped

      # Include stable toolchain for rust-analyzer and other tools
      rustStable

      # Cargo utilities
      cargo-binstall
      cargo-nextest
      cargo-lambda
    ];
  };
}
