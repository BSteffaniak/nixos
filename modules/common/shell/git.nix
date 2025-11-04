{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.shell.git = {
    enable = mkEnableOption "Git and GitHub tools";
  };

  config = mkIf config.myConfig.shell.git.enable {
    environment.systemPackages = with pkgs; [
      git
      gh
      unstable.lazygit
    ];
  };
}
