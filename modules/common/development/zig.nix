{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.zig = {
    enable = mkEnableOption "Zig development environment";
  };

  config = mkIf config.myConfig.development.zig.enable {
    environment.systemPackages = with pkgs; [
      zig
    ];
  };
}
