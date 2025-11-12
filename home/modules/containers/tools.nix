{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.containers.tools;
in
{
  options.myConfig.containers.tools = {
    enable = mkEnableOption "Container debugging and management tools";

    includeDive = mkOption {
      type = types.bool;
      default = true;
      description = "Include dive for exploring image layers";
    };

    includeLazydocker = mkOption {
      type = types.bool;
      default = true;
      description = "Include lazydocker TUI for container management";
    };

    includeCtop = mkOption {
      type = types.bool;
      default = true;
      description = "Include ctop for container monitoring";
    };

    includeSkopeo = mkOption {
      type = types.bool;
      default = true;
      description = "Include skopeo for image operations";
    };

    includeBuildah = mkOption {
      type = types.bool;
      default = false;
      description = "Include buildah for building OCI images";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ ]
      ++ (optional cfg.includeDive dive)
      ++ (optional cfg.includeLazydocker lazydocker)
      ++ (optional cfg.includeCtop ctop)
      ++ (optional cfg.includeSkopeo skopeo)
      ++ (optional cfg.includeBuildah buildah);
  };
}
