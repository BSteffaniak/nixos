{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Gaming
    prismlauncher

    # Password management
    bitwarden-desktop

    # Screenshot tools
    hyprshot

    # Calculator
    qalculate-gtk

    # Music players
    libsForQt5.vvave
    kdePackages.elisa

    # Development tools
    gh-dash
    android-studio
    natscli
    aider-chat

    # Terminal emulator
    unstable.ghostty

    # Cloud tools
    unstable.flyctl

    # Utilities
    brightnessctl
    libinput
    evtest

    # Media tools
    mediainfo
    flac

    # Code tools
    unstable.claude-code
  ];
}
