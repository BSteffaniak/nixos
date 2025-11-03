{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./gtk.nix
    ./xserver.nix
  ];

  options.myConfig.desktop = {
    enable = lib.mkEnableOption "Desktop environment";
  };
}
