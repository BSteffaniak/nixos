{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

with lib;

{
  # Only configure fish when system has fish enabled (myConfig.shell.fish.enable)
  # This provides per-user fish configuration with sensible defaults
  # Override in host-specific home.nix files using homeModules.fish options
  homeModules.fish = mkIf osConfig.myConfig.shell.fish.enable {
    enable = true;
    # aliases defaults to { }
    # functions defaults to { }
    # shellInit defaults to ""
    # interactiveShellInit defaults to ""
    # plugins defaults to [ ]
  };
}
