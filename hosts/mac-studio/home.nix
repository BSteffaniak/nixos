# Personal home-manager overrides for nixos-desktop host
# Contains personal preferences and should not be copied when bootstrapping new hosts
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Fish shell - feature-based configuration
  homeModules.fish = {
    # Zellij
    zellij = {
      enable = true;
      resurrect = true;
    };
  };

  # Personal packages
  home.packages = with pkgs; [
    opencode-dev
  ];
}
