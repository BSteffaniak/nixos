{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./neovim.nix
  ];

  options.myConfig.editors = {
    enable = lib.mkEnableOption "Text editors";
  };
}
