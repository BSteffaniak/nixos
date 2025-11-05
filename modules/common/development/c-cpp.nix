{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.c = {
    enable = mkEnableOption "C/C++ development environment";
  };

  config = mkIf config.myConfig.development.c.enable {
    environment.systemPackages = with pkgs; [
      gcc
      clang
      clang-tools # C/C++ LSP (clangd)
    ];
  };
}
