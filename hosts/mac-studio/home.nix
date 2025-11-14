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
    # CLI tools - mirrored from system config (no need to specify here)

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
          identityFile = "~/.ssh/github_rsa";
        };
      };
    };
  };

  # Personal packages
  home.packages = with pkgs; [
    opencode-dev
  ];
}
