# Personal home-manager overrides for nixos-desktop host
# Contains personal preferences and should not be copied when bootstrapping new hosts
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Fish shell - feature-based configuration
  homeModules.fish = {
    # Zellij
    zellij = {
      enable = true;
      resurrect = true;
    };
  };

  myConfig = {
    # CLI tools configs
    cli-tools.bottom.enable = true;
    cli-tools.htop.enable = true;
    cli-tools.terminals.enable = true;
    cli-tools.tmux.enable = true;

    # Development tool configs
    development.lazygit.enable = true;
    development.act.enable = true;
    development.opencode.enable = true;
    development.ra-multiplex.enable = true;

    # DevOps tool configs
    devops.github = {
      enable = true;
      username = "BSteffaniak";
      gitProtocol = "ssh";
    };

    shell.ssh = {
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "~/.ssh/github";
        };
      };
    };
  };

  # Personal packages
  home.packages = with pkgs; [
    opencode-dev
  ];
}
