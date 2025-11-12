# Standalone home-manager configuration for non-NixOS systems (Ubuntu, etc.)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../modules
    ../common
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Enable XDG base directories
  xdg.enable = true;

  # Default options structure for myConfig
  # These can be overridden in host-specific configs
  options.myConfig = with lib; {
    # These options mirror the system-level ones but work standalone
  };

  # Sensible defaults for standalone usage
  config = {
    # Enable manual pages
    manual.manpages.enable = true;

    # Allow unfree packages (needed for some development tools)
    nixpkgs.config.allowUnfree = true;

    # Set up session variables
    home.sessionVariables = {
      # XDG directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
