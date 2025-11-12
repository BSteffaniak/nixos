{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.devops.github;

  # Generate hosts.yml with configurable GitHub username
  hostsConfig = mkIf (cfg.username != null) {
    "github.com" = {
      users = {
        "${cfg.username}" = { };
      };
      git_protocol = cfg.gitProtocol;
      user = cfg.username;
    };
  };
in
{
  options.myConfig.devops.github = {
    enable = mkEnableOption "GitHub CLI and tools configuration";

    username = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "GitHub username (set per-host to avoid hardcoding)";
    };

    gitProtocol = mkOption {
      type = types.enum [
        "ssh"
        "https"
      ];
      default = "ssh";
      description = "Git protocol to use for GitHub operations";
    };
  };

  config = mkIf cfg.enable {
    # Install gh package (don't use programs.gh to avoid conflicts)
    home.packages = with pkgs; [ gh ];

    # Manually symlink standalone GitHub CLI configs from configs/gh
    xdg.configFile = {
      "gh/config.yml".source = ../../../configs/gh/config.yml;
      "gh-dash/config.yml".source = ../../../configs/gh/gh-dash/config.yml;

      # Generate hosts.yml dynamically from username option
      "gh/hosts.yml" = mkIf (cfg.username != null) {
        text = lib.generators.toYAML { } hostsConfig;
      };
    };
  };
}
