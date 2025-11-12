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

    monitorsConfig = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to host-specific monitors.conf (should be set per-host)";
    };

    workspacesConfig = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to host-specific workspaces.conf (optional)";
    };
  };

  config = mkIf cfg.enable {
    # Symlink standalone hyprland config from configs/hyprland
    xdg.configFile = {
      # Shared config and scripts
      "hypr/hyprland.conf".source = ../../../configs/hyprland/hyprland.conf;
      "hypr/display_off.sh" = {
        source = ../../../configs/hyprland/display_off.sh;
        executable = true;
      };
      "hypr/winfzf.sh" = {
        source = ../../../configs/hyprland/winfzf.sh;
        executable = true;
      };

      # Host-specific configs (only if provided)
      "hypr/monitors.conf" = mkIf (cfg.monitorsConfig != null) {
        source = cfg.monitorsConfig;
      };
      "hypr/workspaces.conf" = mkIf (cfg.workspacesConfig != null) {
        source = cfg.workspacesConfig;
      };
    };
  };
}
