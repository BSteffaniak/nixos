# Ubuntu Laptop - Standalone Home Manager Configuration
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../home/standalone
    ../../home/standalone/ubuntu.nix
  ];

  # User info
  home.username = "braden";
  home.homeDirectory = "/home/braden";
  home.stateVersion = "25.05";

  # Enable all the development tools and features
  myConfig = {
    # Development environments
    development.rust.enable = true;
    development.rust.includeNightly = true;
    development.nodejs.enable = true;
    development.go.enable = true;
    development.python.enable = true;
    development.zig.enable = true;

    # Containers - rootless!
    containers.podman.enable = true;
    containers.podman.dockerCompatibility = true;
    containers.podman.composeEnable = true;
    containers.tools.enable = true;

    # DevOps tools
    devops.kubernetes.enable = true;
    devops.cloud.enable = true;
    devops.infrastructure.enable = true;

    # Shell configuration
    shell.fish.enable = true;
    shell.git.enable = true;
    shell.ssh.enable = true;

    # Editors
    editors.neovim.enable = true;
    editors.neovim.useNightly = true;

    # CLI Tools
    cliTools.enable = true;
  };

  # Ubuntu laptop specific packages
  home.packages = with pkgs; [
    # Add any laptop-specific tools here
  ];
}
