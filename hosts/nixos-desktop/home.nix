# Personal home-manager overrides for nixos-desktop host
# Contains personal preferences and should not be copied when bootstrapping new hosts
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable GTK theming with personal preferences
  homeModules.gtkTheming = {
    enable = true;
    theme = "Juno";
    themePackage = pkgs.juno-theme;
    iconTheme = "Papirus-Dark";
    iconThemePackage = pkgs.papirus-icon-theme;
    cursorTheme = "Bibata-Modern-Classic";
    cursorThemePackage = pkgs.bibata-cursors;
    font = {
      name = "TeX Gyre Adventor";
      size = 10;
    };
  };

  # Fish shell - feature-based configuration
  homeModules.fish = {
    # Flat Project (includes logging and airship)
    flat = {
      enable = true;
      logging = true;
      airship = true;
    };

    # Zellij
    zellij = {
      enable = true;
      resurrect = true;
    };

    # OpenCode
    opencode = {
      enable = true;
      devMode = false;
      projectPath = "/hdd/GitHub/opencode";
    };

    # Development Tools
    development = {
      enable = true;
      benchmark = true;
    };
  };

  # Personal packages
  home.packages = with pkgs; [
    steam
    opencode-dev
  ];
}
