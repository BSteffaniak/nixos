{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.c;
in
{
  options.myConfig.development.c = {
    enable = mkEnableOption "C/C++ development environment";

    includeLSP = mkOption {
      type = types.bool;
      default = true;
      description = "Include clangd language server";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        gcc
        clang
      ]
      ++ (optional cfg.includeLSP clang-tools);
  };
}
