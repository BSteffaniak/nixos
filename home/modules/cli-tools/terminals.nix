{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cli-tools.terminals;
in
{
  options.myConfig.cli-tools.terminals = {
    enable = mkEnableOption "Terminal emulator configurations";

    ghostty = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Ghostty terminal configuration";
    };

    wezterm = mkOption {
      type = types.bool;
      default = true;
      description = "Enable WezTerm terminal configuration";
    };

    zellij = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Zellij terminal workspace configuration";
    };
  };

  config = mkIf cfg.enable {
    # Ghostty config
    xdg.configFile."ghostty/config" = mkIf cfg.ghostty {
      source = ../../../configs/ghostty/config;
    };

    # WezTerm config
    programs.wezterm = mkIf cfg.wezterm {
      enable = true;
      extraConfig = builtins.readFile ../../../configs/wezterm/wezterm.lua;
    };

    # Zellij config
    programs.zellij = mkIf cfg.zellij {
      enable = true;
    };
    xdg.configFile."zellij/config.kdl" = mkIf cfg.zellij {
      source = ../../../configs/zellij/config.kdl;
    };
  };
}
