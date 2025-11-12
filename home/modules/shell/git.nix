# This integrates the existing home/modules/git.nix with myConfig options
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.shell.git;
in
{
  options.myConfig.shell.git = {
    enable = mkEnableOption "Git configuration";

    userName = mkOption {
      type = types.str;
      default = "Braden Steffaniak";
      description = "Git user name";
    };

    userEmail = mkOption {
      type = types.str;
      default = "BradenSteffaniak@gmail.com";
      description = "Git user email";
    };
  };

  config = mkIf cfg.enable {
    # Enable the existing homeModules.git configuration
    homeModules.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
    };
  };
}
