{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.lazygit;
in
{
  options.myConfig.development.lazygit = {
    enable = mkEnableOption "LazyGit TUI configuration";
  };

  config = mkIf cfg.enable {
    programs.lazygit.enable = true;

    # Symlink standalone lazygit config from configs/lazygit
    xdg.configFile."lazygit/config.yml".source = ../../../configs/lazygit/config.yml;
  };
}
