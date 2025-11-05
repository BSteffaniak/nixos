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
    ./podman.nix
    ./python.nix
    ./android.nix
    ./devops.nix
    ./zig.nix
    ./openssl.nix
    ./java.nix
    ./dotnet.nix
    ./c-cpp.nix
    ./elixir.nix
  ];

  options.myConfig.development = {
    enable = lib.mkEnableOption "Development environment";
  };
}
