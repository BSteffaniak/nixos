{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.fileTools;

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
  options.myConfig.cliTools.fileTools = {
    enableAll = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all file tools (can be overridden per-tool)";
    };

    fzf.enable = mkEnable "Fuzzy finder";
    ripgrep.enable = mkEnable "Ripgrep search tool";
    fd.enable = mkEnable "Fd file finder";
    unzip.enable = mkEnable "Unzip utility";
    zip.enable = mkEnable "Zip utility";
  };

  config = {
    home.packages = mkMerge [
      (mkIf cfg.fzf.enable [ pkgs.fzf ])
      (mkIf cfg.ripgrep.enable [ pkgs.ripgrep ])
      (mkIf cfg.fd.enable [ pkgs.fd ])
      (mkIf cfg.unzip.enable [ pkgs.unzip ])
      (mkIf cfg.zip.enable [ pkgs.zip ])
    ];
  };
}
