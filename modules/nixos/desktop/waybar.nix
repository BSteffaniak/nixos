{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.desktop.waybar = {
    enable = mkEnableOption "Waybar status bar";
  };

  config = mkIf config.myConfig.desktop.waybar.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    };
  };
}
