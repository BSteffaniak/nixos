{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.system.security = {
    enable = mkEnableOption "Security configuration";
  };

  config = mkIf config.myConfig.system.security.enable {
    security = {
      pam.services.swaylock = {
        text = ''
          auth include login
        '';
      };
      rtkit.enable = true;
    };
  };
}
