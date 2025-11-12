{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cli-tools.bottom;
in
{
  options.myConfig.cli-tools.bottom = {
    enable = mkEnableOption "Bottom system monitor configuration";
  };

  config = mkIf cfg.enable {
    programs.bottom.enable = true;

    # Symlink standalone bottom config from configs/bottom
    xdg.configFile."bottom/bottom.toml".source = ../../../configs/bottom/bottom.toml;
  };
}
