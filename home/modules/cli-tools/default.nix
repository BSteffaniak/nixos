{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools;
in
{
  imports = [
    ./bottom.nix
    ./htop.nix
    ./terminals.nix
    ./tmux.nix
  ];
  options.myConfig.cliTools = {
    enable = mkEnableOption "CLI tools and utilities";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Terminal multiplexers and managers
      tmux
      zellij

      # System monitoring
      htop
      bottom
      ncdu

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
      unstable.opencode
      unstable.claude-code
    ];

    # Enable direnv integration with shell
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
