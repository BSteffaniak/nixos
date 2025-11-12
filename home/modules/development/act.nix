{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.act;
in
{
  options.myConfig.development.act = {
    enable = mkEnableOption "Act (GitHub Actions locally) configuration";
  };

  config = mkIf cfg.enable {
    xdg.configFile."act/actrc".source = ../../../configs/act/actrc;
  };
}
