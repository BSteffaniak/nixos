{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.java;
in
{
  options.myConfig.development.java = {
    enable = mkEnableOption "Java development environment";

    includeKotlin = mkOption {
      type = types.bool;
      default = true;
      description = "Include Kotlin language server";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        maven
      ]
      ++ (optional cfg.includeKotlin kotlin-language-server);
  };
}
