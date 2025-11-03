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
  home.homeDirectory = "/home/braden";
  home.stateVersion = "24.11";

  # NixOS-specific packages
  home.packages = with pkgs; [
    steam
  ];

  # GTK configuration
  gtk = {
    enable = true;
    font.name = "TeX Gyre Adventor";
    font.size = 10;
    theme = {
      name = "Juno";
      package = pkgs.juno-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
      "gtk-cursor-theme-name" = "Bibata-Modern-Classic";
    };

    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
      "gtk-cursor-theme-name" = "Bibata-Modern-Classic";
    };
  };

  # NixOS-specific home files
  home.file = {
    ".config/systemd/user/tmux.service.d/override.conf".text = ''
      [Install]

      [Service]
      ExecStart=

      [Unit]
    '';
  };
}
