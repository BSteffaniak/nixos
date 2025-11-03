{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.nixos.cliTools = {
    enable = mkEnableOption "NixOS-specific CLI tools and utilities";
  };

  config = mkIf config.myConfig.nixos.cliTools.enable {
    environment.systemPackages = with pkgs; [
      nethogs
      bandwhich
    ];
  };
}
