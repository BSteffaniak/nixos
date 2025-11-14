{
  config,
  lib,
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
  };
}
