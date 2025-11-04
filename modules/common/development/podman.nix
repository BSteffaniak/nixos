{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.podman = {
    enable = mkEnableOption "Podman container runtime";
  };

  config = mkIf config.myConfig.development.podman.enable {
    environment.systemPackages = with pkgs; [
      podman
    ];
  };
}
