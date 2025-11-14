{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.formatters;

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
  options.myConfig.cliTools.formatters = {
    enableAll = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all code formatters (can be overridden per-tool)";
    };

    nixfmt.enable = mkEnable "Nix formatter (nixfmt-rfc-style)";
    eslint.enable = mkEnable "ESLint daemon";
    prettier.enable = mkEnable "Prettier daemon";
    taplo.enable = mkEnable "TOML formatter";
  };
}
