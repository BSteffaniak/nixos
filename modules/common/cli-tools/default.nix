{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.cliTools = {
    enable = mkEnableOption "CLI tools and utilities";
  };

  config = mkIf config.myConfig.cliTools.enable {
    environment.systemPackages = with pkgs; [
      # Terminal multiplexers and managers
      tmux
      zellij

      # System monitoring
      htop
      bottom
      nethogs
      ncdu
      bandwhich

      # File management
      fzf
      ripgrep
      fd
      unzip
      zip

      # Network tools
      lsof

      # Process management
      killall

      # Text processing
      jq

      # Code formatting
      nixfmt-rfc-style
      eslint_d
      prettierd
      taplo

      # Search
      nix-search

      # Other utilities
      direnv
      parallel
      write-good
      cloc
      watchexec
      mediainfo
      flac
      ffmpeg
    ];
  };
}
