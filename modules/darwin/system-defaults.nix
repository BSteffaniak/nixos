{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.darwin.systemDefaults = {
    enable = mkEnableOption "macOS system defaults";
  };

  config = mkIf config.myConfig.darwin.systemDefaults.enable {
    system.defaults = {
      dock.autohide = true;
    };
  };
}
