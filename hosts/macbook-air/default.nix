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
    development.rust.includeNightly = true;
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

  # System packages specific to this host
  environment.systemPackages = with pkgs; [
    unstable.bpf-linker
    libiconv # Required for building chadthrottle on macOS
  ];

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
