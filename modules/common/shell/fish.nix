{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.shell.fish = {
    enable = mkEnableOption "Fish shell";
  };

  config = mkIf config.myConfig.shell.fish.enable {
    programs.fish.enable = true;
  };
}
