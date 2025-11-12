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
      projectPath = "/hdd/GitHub/opencode";
    };

    # Development Tools
    development = {
      enable = true;
      benchmark = true;
    };
  };

  # Enable standalone config modules
  myConfig = {
    # CLI tools configs
    cli-tools.bottom.enable = true;
    cli-tools.htop.enable = true;
    cli-tools.terminals.enable = true;
    cli-tools.tmux.enable = true;

    # Development tool configs
    development.lazygit.enable = true;
    development.act.enable = true;
    development.opencode.enable = true;
    development.ra-multiplex.enable = true;

    # DevOps tool configs
    devops.github.enable = true;

    # Desktop utility configs
    desktop.utilities.enable = true;
  };

  # Personal packages
  home.packages = with pkgs; [
    steam
    opencode-dev
  ];
}
