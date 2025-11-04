{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./docker.nix
    ./observability.nix
  ];

  options.myConfig.services = {
    enable = lib.mkEnableOption "System services";
  };
}
