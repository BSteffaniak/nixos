{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.zig;
in
{
  options.myConfig.development.zig = {
    enable = mkEnableOption "Zig development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ zig ];
  };
}
