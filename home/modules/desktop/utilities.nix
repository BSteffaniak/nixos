{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.desktop.utilities;
in
{
  options.myConfig.desktop.utilities = {
    enable = mkEnableOption "Desktop utilities configuration";

    fuzzel = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Fuzzel application launcher configuration";
    };

    waypaper = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Waypaper wallpaper manager configuration";
    };
  };

  config = mkIf cfg.enable {
    # Fuzzel application launcher and Waypaper wallpaper manager
    xdg.configFile = {
      "fuzzel/fuzzel.ini" = mkIf cfg.fuzzel {
        source = ../../../configs/fuzzel/fuzzel.ini;
      };

      "waypaper/config.ini" = mkIf cfg.waypaper {
        source = ../../../configs/waypaper/config.ini;
      };

      "waypaper/random-wallpaper.sh" = mkIf cfg.waypaper {
        source = ../../../configs/waypaper/random-wallpaper.sh;
        executable = true;
      };
    };
  };
}
