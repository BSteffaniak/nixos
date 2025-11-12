{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cli-tools.tmux;
in
{
  options.myConfig.cli-tools.tmux = {
    enable = mkEnableOption "Tmux terminal multiplexer configuration";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      # Read the entire standalone config
      extraConfig = builtins.readFile ../../../configs/tmux/tmux.conf;
    };

    # Note: Tmux plugins are managed by tpm (Tmux Plugin Manager)
    # which will automatically install them on first launch
  };
}
