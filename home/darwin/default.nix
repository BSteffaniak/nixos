{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
  ];

  home.username = "braden";
  home.homeDirectory = "/Users/braden";
  home.stateVersion = "24.11";

  # Darwin-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
  ];
}
