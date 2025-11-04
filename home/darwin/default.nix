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
    ../modules
  ];

  home.username = osConfig.myConfig.username;
  home.homeDirectory = lib.mkForce "/Users/${osConfig.myConfig.username}";

  # State version should match the Darwin release when home-manager was first used
  # Darwin state version is an integer, convert from system config
  home.stateVersion = builtins.toString osConfig.system.stateVersion;

  # Darwin-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
  ];
}
