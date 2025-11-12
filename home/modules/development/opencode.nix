{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.opencode;
in
{
  options.myConfig.development.opencode = {
    enable = mkEnableOption "OpenCode AI assistant configuration";
  };

  config = mkIf cfg.enable {
    # Only symlink the main opencode config file
    xdg.configFile."opencode/opencode.json".source = ../../../configs/opencode/opencode.json;
  };
}
