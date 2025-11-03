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
      rustup
      cargo-nextest
      cargo-lambda
    ];
  };
}
