{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./rust.nix
    ./nodejs.nix
    ./go.nix
    ./python.nix
    ./android.nix
    ./devops.nix
    ./zig.nix
  ];

  options.myConfig.development = {
    enable = lib.mkEnableOption "Development environment";
  };
}
