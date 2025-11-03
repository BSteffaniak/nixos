{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./nvidia.nix
    ./graphics.nix
  ];

  options.myConfig.hardware = {
    enable = lib.mkEnableOption "Hardware configuration";
  };
}
