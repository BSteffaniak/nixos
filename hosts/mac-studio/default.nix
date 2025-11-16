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
    homeManagerStateVersion = "24.11";

    # Development tools
    development.rust.enable = true;
    development.nodejs.enable = true;
    development.go.enable = true;
    development.python.enable = false;
    development.android.enable = false;
    development.devops.enable = true;
    development.podman.enable = true;
    development.openssl.enable = true;
    development.java.enable = true;

    # Shell and editors
    shell.fish.enable = true;
    shell.git.enable = true;
    shell.ssh.enable = true;
    shell.ssh.server.enable = true;
    editors.neovim.enable = true;
    editors.neovim.useNightly = true;

    # CLI tools - granular enables matching home-manager
    cliTools = {
      terminals.zellij.enable = true;
      terminals.tmux.enable = true;

      monitoring.bottom.enable = true;
      monitoring.htop.enable = true;
      monitoring.ncdu.enable = true;

      fileTools.fzf.enable = true;
      fileTools.ripgrep.enable = true;
      fileTools.fd.enable = true;
      fileTools.unzip.enable = true;
      fileTools.zip.enable = true;

      formatters.nixfmt.enable = true;
      formatters.eslint.enable = true;
      formatters.prettier.enable = true;
      formatters.taplo.enable = true;

      utilities.direnv.enable = true;
      utilities.jq.enable = true;
      utilities.parallel.enable = true;
      utilities.write-good.enable = true;
      utilities.cronstrue.enable = true;
      utilities.cloc.enable = true;
      utilities.watchexec.enable = true;
      utilities.lsof.enable = true;
      utilities.killall.enable = true;
      utilities.nix-search.enable = true;
      utilities.media.ffmpeg.enable = true;
      utilities.media.flac.enable = true;
      utilities.media.mediainfo.enable = true;
      utilities.opencode.enable = true;
    };

    # Darwin-specific
    darwin.homebrew.enable = true;
    darwin.systemDefaults.enable = true;
    darwin.applications.enable = true;
  };

  environment.systemPackages = [
    inputs.home-manager.packages."${pkgs.system}".default
  ];

  # Networking
  networking.hostName = "Bradens-Mac-Studio";
  networking.computerName = "Braden's Mac Studio";

  # User configuration
  system.primaryUser = "bsteffaniak";

  # System version
  system.stateVersion = 6;

  # Platform - adjust this if your Mac Studio is Intel
  nixpkgs.hostPlatform = "aarch64-darwin"; # Change to "x86_64-darwin" if Intel
}
