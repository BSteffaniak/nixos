{ pkgs, ... }:

let
  android = import ./android.nix { inherit pkgs; };
  sessionVariables = {
    # EDITOR = "emacs";
    ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
    NDK_HOME = "${android.androidsdk}/libexec/android-sdk/ndk-bundle";
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "braden";
  home.homeDirectory = "/home/braden";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    prismlauncher
    bitwarden-desktop
    hyprshot
    qalculate-gtk
    steam
    libsForQt5.vvave
    kdePackages.elisa
    cloc
    watchexec
    gh-dash
    android-studio
    fd
    natscli
    bottom
    bandwhich
    brightnessctl
    libinput
    evtest
    stern
    aider-chat
    android.androidsdk
    unstable.ghostty
    unstable.code-cursor
    opentofu
    mediainfo
    flac
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/systemd/user/tmux.service.d/override.conf".text = ''
      [Install]

      [Service]
      ExecStart=

      [Unit]
    '';

    # ".npmrc".text = ''
    #   prefix=~/.npm-packages
    # '';

    # ".config/gtk-3.0/settings.ini" = {
    #   text = ''
    #     # gtk-3.0
    #     [Settings]
    #     gtk-application-prefer-dark-theme=1
    #     gtk-cursor-theme-name=Bibata-Modern-Classic
    #   '';
    #   force = true;
    # };

    # ".config/gtk-4.0/settings.ini" = {
    #   text = ''
    #     # gtk-4.0
    #     [Settings]
    #     gtk-application-prefer-dark-theme=1
    #     gtk-cursor-theme-name=Bibata-Modern-Classic
    #   '';
    #   force = true;
    # };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/braden/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = sessionVariables;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-packages/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      . ~/.rc-files/env.sh

      # Flat
      . ~/.flat/env
    '';
    sessionVariables = sessionVariables;
  };

  programs.git = {
    enable = true;
    userName = "Braden Steffaniak";
    userEmail = "BradenSteffaniak@gmail.com";
  };

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

}
