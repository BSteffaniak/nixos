{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.monitoring;
in
{
  options.myConfig.cliTools.monitoring = {
    bottom.enable = mkEnableOption "Bottom system monitor";
    htop.enable = mkEnableOption "Htop system monitor";
    ncdu.enable = mkEnableOption "NCurses Disk Usage analyzer";
  };

  config = {
    environment.systemPackages = mkMerge [
      (mkIf cfg.bottom.enable [ pkgs.bottom ])
      (mkIf cfg.htop.enable [ pkgs.htop ])
      (mkIf cfg.ncdu.enable [ pkgs.ncdu ])
    ];
  };
}
