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
    username = "bsteffaniak";
    fullName = "Braden Steffaniak";

    # Development tools
    development.rust.enable = true;
    development.nodejs.enable = true;
    development.go.enable = true;
    development.python.enable = true;
    development.android.enable = true;
    development.devops.enable = true;

    # Shell and editors
    shell.fish.enable = true;
    shell.git.enable = true;
    editors.neovim.enable = true;
    editors.neovim.useNightly = false;

    # CLI tools
    cliTools.enable = true;

    # Darwin-specific
    darwin.homebrew.enable = true;
    darwin.systemDefaults.enable = true;
    darwin.applications.enable = true;
  };

  # Networking
  networking.hostName = "Bradens-Mac-Mini";
  networking.computerName = "Braden's Mac Mini";

  # User configuration
  system.primaryUser = "bsteffaniak";

  # System version
  system.stateVersion = 6;

  # Platform - adjust this if your Mac Mini is Intel
  nixpkgs.hostPlatform = "aarch64-darwin"; # Change to "x86_64-darwin" if Intel
}
