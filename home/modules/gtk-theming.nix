{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.homeModules.gtkTheming = {
    enable = mkEnableOption "GTK theming configuration";

    theme = mkOption {
      type = types.str;
      default = "Adwaita-dark";
      description = "GTK theme name";
    };

    themePackage = mkOption {
      type = types.package;
      default = pkgs.gnome-themes-extra;
      description = "GTK theme package";
    };

    iconTheme = mkOption {
      type = types.str;
      default = "Adwaita";
      description = "Icon theme name";
    };

    iconThemePackage = mkOption {
      type = types.package;
      default = pkgs.adwaita-icon-theme;
      description = "Icon theme package";
    };

    cursorTheme = mkOption {
      type = types.str;
      default = "Adwaita";
      description = "Cursor theme name";
    };

    cursorThemePackage = mkOption {
      type = types.package;
      default = pkgs.adwaita-icon-theme;
      description = "Cursor theme package";
    };

    font = {
      name = mkOption {
        type = types.str;
        default = "Sans";
        description = "GTK font name";
      };

      size = mkOption {
        type = types.int;
        default = 11;
        description = "GTK font size";
      };
    };
  };

  config = mkIf config.homeModules.gtkTheming.enable {
    gtk = {
      enable = true;

      font = {
        name = config.homeModules.gtkTheming.font.name;
        size = config.homeModules.gtkTheming.font.size;
      };

      theme = {
        name = config.homeModules.gtkTheming.theme;
        package = config.homeModules.gtkTheming.themePackage;
      };

      iconTheme = {
        name = config.homeModules.gtkTheming.iconTheme;
        package = config.homeModules.gtkTheming.iconThemePackage;
      };

      cursorTheme = {
        name = config.homeModules.gtkTheming.cursorTheme;
        package = config.homeModules.gtkTheming.cursorThemePackage;
      };

      gtk3.extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
        "gtk-cursor-theme-name" = config.homeModules.gtkTheming.cursorTheme;
      };

      gtk4.extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
        "gtk-cursor-theme-name" = config.homeModules.gtkTheming.cursorTheme;
      };
    };
  };
}
