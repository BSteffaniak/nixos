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
    # Bottom
    programs.bottom.enable = cfg.bottom.enable;
    xdg.configFile."bottom/bottom.toml" = mkIf cfg.bottom.enable {
      source = ../../../configs/bottom/bottom.toml;
    };

    # Htop
    home.packages = mkMerge [
      (mkIf cfg.htop.enable [ pkgs.htop ])
      (mkIf cfg.ncdu.enable [ pkgs.ncdu ])
    ];
    xdg.configFile."htop/htoprc" = mkIf cfg.htop.enable {
      source = ../../../configs/htop/htoprc;
    };
  };
}
