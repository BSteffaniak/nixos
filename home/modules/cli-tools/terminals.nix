{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.terminals;
in
{
  options.myConfig.cliTools.terminals = {
    zellij.enable = mkEnableOption "Zellij terminal workspace";
    tmux.enable = mkEnableOption "Tmux terminal multiplexer";
    wezterm.enable = mkEnableOption "WezTerm terminal emulator";
    ghostty.enable = mkEnableOption "Ghostty terminal emulator";
  };

  config = {
    # Zellij
    programs.zellij.enable = cfg.zellij.enable;
    xdg.configFile."zellij/config.kdl" = mkIf cfg.zellij.enable {
      source = ../../../configs/zellij/config.kdl;
    };
    xdg.configFile."zellij/plugins" = mkIf cfg.zellij.enable {
      source = ../../../configs/zellij/plugins;
      recursive = true;
    };

    # Tmux
    programs.tmux = mkIf cfg.tmux.enable {
      enable = true;
      extraConfig = builtins.readFile ../../../configs/tmux/tmux.conf;
    };

    # WezTerm
    programs.wezterm = mkIf cfg.wezterm.enable {
      enable = true;
      extraConfig = builtins.readFile ../../../configs/wezterm/wezterm.lua;
    };

    # Ghostty
    xdg.configFile."ghostty/config" = mkIf cfg.ghostty.enable {
      source = ../../../configs/ghostty/config;
    };
  };
}
