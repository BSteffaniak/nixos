{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.services.docker = {
    enable = mkEnableOption "Docker container runtime";
    dataRoot = mkOption {
      type = types.str;
      default = "/var/lib/docker";
      description = "Docker data root directory";
    };
  };

  config = mkIf config.myConfig.services.docker.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        data-root = config.myConfig.services.docker.dataRoot;
      };
    };
  };
}
