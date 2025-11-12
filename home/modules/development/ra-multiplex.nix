{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.ra-multiplex;
in
{
  options.myConfig.development.ra-multiplex = {
    enable = mkEnableOption "Rust Analyzer multiplexer configuration";
  };

  config = mkIf cfg.enable {
    xdg.configFile."ra-multiplex/config.toml".source = ../../../configs/ra-multiplex/config.toml;
  };
}
