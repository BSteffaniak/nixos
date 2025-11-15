{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.terminals;

  # Helper for enable options with custom default
  mkEnableOption' =
    defaultValue: description:
    mkOption {
      type = types.bool;
      default = defaultValue;
      description = "Enable ${description}";
    };

  mkEnable = mkEnableOption' cfg.enableAll;
in
{
  options.myConfig.cliTools.terminals = {
    enableAll = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all terminal tools (can be overridden per-tool)";
    };

    zellij.enable = mkEnable "Zellij terminal workspace";
    tmux.enable = mkEnable "Tmux terminal multiplexer";
    wezterm.enable = mkEnable "WezTerm terminal emulator";
    ghostty.enable = mkEnable "Ghostty terminal emulator";
  };

  config = {
    # Zellij - use custom package when available
    programs.zellij = mkIf cfg.zellij.enable {
      enable = true;
      package = pkgs.zellij-custom or pkgs.zellij;
    };
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
