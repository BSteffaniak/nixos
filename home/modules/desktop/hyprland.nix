# User-level Hyprland configuration
# Note: The Hyprland compositor itself must be installed at system level
# This module only manages user configuration files
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.desktop.hyprland;
in
{
  options.myConfig.desktop.hyprland = {
    enable = mkEnableOption "Hyprland window manager configuration";
  };

  config = mkIf cfg.enable {
    # User-level Hyprland configuration will go here
    # For now, this is a placeholder for future config files
    home.file.".config/hypr/.keep".text = "";
  };
}
