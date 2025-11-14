{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.monitoring;

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
  options.myConfig.cliTools.monitoring = {
    enableAll = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all system monitoring tools (can be overridden per-tool)";
    };

    bottom.enable = mkEnable "Bottom system monitor";
    htop.enable = mkEnable "Htop system monitor";
    ncdu.enable = mkEnable "NCurses Disk Usage analyzer";
  };
}
