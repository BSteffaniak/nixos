{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.monitoring;

  # Helper for enable options with custom default
  mkEnableOption' =
    defaultValue: description:
    mkOption {
      type = types.bool;
      default = defaultValue;
      description = "Enable ${description}";
    };

  mkEnable = mkEnableOption' cfg.enableAll;
in
{
  options.myConfig.cliTools.monitoring = {
    enableAll = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all monitoring tools (can be overridden per-tool)";
    };

    bottom.enable = mkEnable "Bottom system monitor";
    htop.enable = mkEnable "Htop system monitor";
    ncdu.enable = mkEnable "NCurses Disk Usage analyzer";
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
