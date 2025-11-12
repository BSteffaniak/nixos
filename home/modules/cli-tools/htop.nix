{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cli-tools.htop;
in
{
  options.myConfig.cli-tools.htop = {
    enable = mkEnableOption "htop system monitor configuration";
  };

  config = mkIf cfg.enable {
    programs.htop.enable = true;

    xdg.configFile."htop/htoprc".source = ../../../configs/htop/htoprc;
  };
}
