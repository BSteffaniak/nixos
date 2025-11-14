{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.terminals;
in
{
  options.myConfig.cliTools.terminals = {
    zellij.enable = mkEnableOption "Zellij terminal workspace";
    tmux.enable = mkEnableOption "Tmux terminal multiplexer";
  };

  config = {
    environment.systemPackages = mkMerge [
      (mkIf cfg.zellij.enable [ pkgs.zellij ])
      (mkIf cfg.tmux.enable [ pkgs.tmux ])
    ];
  };
}
