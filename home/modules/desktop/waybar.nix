# User-level Waybar configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.desktop.waybar;
in
{
  options.myConfig.desktop.waybar = {
    enable = mkEnableOption "Waybar status bar configuration";
  };

  config = mkIf cfg.enable {
    # Symlink standalone waybar config from configs/waybar
    xdg.configFile = {
      "waybar/config.jsonc".source = ../../../configs/waybar/config.jsonc;
      "waybar/style.css".source = ../../../configs/waybar/style.css;
      "waybar/power_menu.xml".source = ../../../configs/waybar/power_menu.xml;
    };
  };
}
