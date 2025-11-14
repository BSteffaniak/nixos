{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.utilities;
in
{
  options.myConfig.cliTools.utilities = {
    direnv = {
      enable = mkEnableOption "Direnv for per-directory environments";
      nix-direnv = mkOption {
        type = types.bool;
        default = true;
        description = "Enable nix-direnv integration";
      };
    };

    jq.enable = mkEnableOption "JSON processor";
    parallel.enable = mkEnableOption "GNU parallel";
    write-good.enable = mkEnableOption "Writing quality checker";
    cloc.enable = mkEnableOption "Lines of code counter";
    watchexec.enable = mkEnableOption "File watcher/executor";
    lsof.enable = mkEnableOption "List open files utility";
    killall.enable = mkEnableOption "Killall utility";
    nix-search.enable = mkEnableOption "Nix package search";

    media = {
      ffmpeg.enable = mkEnableOption "FFmpeg media processor";
      flac.enable = mkEnableOption "FLAC codec";
      mediainfo.enable = mkEnableOption "Media info analyzer";
    };

    opencode.enable = mkEnableOption "OpenCode and Claude Code";
  };

  config = {
    # Direnv
    programs.direnv = mkIf cfg.direnv.enable {
      enable = true;
      nix-direnv.enable = cfg.direnv.nix-direnv;
    };

    # Package installs
    home.packages = mkMerge [
      (mkIf cfg.jq.enable [ pkgs.jq ])
      (mkIf cfg.parallel.enable [ pkgs.parallel ])
      (mkIf cfg.write-good.enable [ pkgs.write-good ])
      (mkIf cfg.cloc.enable [ pkgs.cloc ])
      (mkIf cfg.watchexec.enable [ pkgs.watchexec ])
      (mkIf cfg.lsof.enable [ pkgs.lsof ])
      (mkIf cfg.killall.enable [ pkgs.killall ])
      (mkIf cfg.nix-search.enable [ pkgs.nix-search ])
      (mkIf cfg.media.ffmpeg.enable [ pkgs.ffmpeg ])
      (mkIf cfg.media.flac.enable [ pkgs.flac ])
      (mkIf cfg.media.mediainfo.enable [ pkgs.mediainfo ])
      (mkIf cfg.opencode.enable [
        pkgs.unstable.opencode
        pkgs.unstable.claude-code
      ])
    ];
  };
}
