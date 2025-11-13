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
    # macOS uses ~/Library/Application Support, Linux uses ~/.config
    home.file = mkIf pkgs.stdenv.isDarwin {
      "Library/Application Support/lazygit/config.yml".source = ../../../configs/lazygit/config.yml;
    };

    xdg.configFile = mkIf (!pkgs.stdenv.isDarwin) {
      "lazygit/config.yml".source = ../../../configs/lazygit/config.yml;
    };
  };
}
