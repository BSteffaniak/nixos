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
  # Use the homeManagerStateVersion from host config
  home.stateVersion = osConfig.myConfig.homeManagerStateVersion;

  # Darwin-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
  ];
}
