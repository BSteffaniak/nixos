{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/common
    ../../modules/darwin
  ];

  # Host-specific settings
  myConfig = {
    username = "braden";
    fullName = "Braden Steffaniak";
    homeManagerStateVersion = "24.11";

    # Development tools
    development.rust.enable = true;
    development.nodejs.enable = true;
    development.go.enable = true;
    development.python.enable = true;
    development.android.enable = false;
    development.devops.enable = true;
    development.podman.enable = true;
    development.openssl.enable = true;

    # Shell and editors
    shell.fish.enable = true;
    shell.git.enable = true;
    editors.neovim.enable = true;
    editors.neovim.useNightly = true;

    # CLI tools
    cliTools.enable = true;

    # Darwin-specific
    darwin.homebrew.enable = true;
    darwin.systemDefaults.enable = true;
    darwin.applications.enable = true;
  };

  # Networking
  networking.hostName = "Bradens-MacBook-Air";
  networking.computerName = "Braden's MacBook Air";

  # User configuration
  system.primaryUser = "braden";

  # System version
  system.stateVersion = 6;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
