{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.utilities;

  # Helper for enable options with custom default
  mkEnableOption' =
    defaultValue: description:
    mkOption {
      type = types.bool;
      default = defaultValue;
      description = "Enable ${description}";
    };

  mkEnable = mkEnableOption' cfg.enableAll;
  mkMediaEnable = mkEnableOption' cfg.media.enableAll;
in
{
  options.myConfig.cliTools.utilities = {
    enableAll = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all utility tools (can be overridden per-tool)";
    };

    direnv.enable = mkEnable "Direnv for per-directory environments";
    jq.enable = mkEnable "JSON processor";
    parallel.enable = mkEnable "GNU parallel";
    write-good.enable = mkEnable "writing quality checker";
    cronstrue.enable = mkEnable "cron expression diagnostic tool";
    cloc.enable = mkEnable "lines of code counter";
    watchexec.enable = mkEnable "file watcher/executor";
    lsof.enable = mkEnable "list open files utility";
    killall.enable = mkEnable "killall utility";
    nix-search.enable = mkEnable "Nix package search";

    media = {
      enableAll = mkOption {
        type = types.bool;
        default = cfg.enableAll;
        description = "Enable all media tools (can be overridden per-tool)";
      };

      ffmpeg.enable = mkMediaEnable "FFmpeg media processor";
      flac.enable = mkMediaEnable "FLAC codec";
      mediainfo.enable = mkMediaEnable "media info analyzer";
    };

    opencode.enable = mkEnable "OpenCode and Claude Code";
  };
}
