{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  imports = [
    ../common
  ];

  home.username = osConfig.myConfig.username;
  home.homeDirectory = lib.mkForce "/Users/${osConfig.myConfig.username}";
  home.stateVersion = "24.11";

  # Darwin-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
  ];
}
