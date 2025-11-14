{
  config,
  lib,
  pkgs,
  osConfig,
  inputs ? { },
  ...
}:

{
  imports = [
    ../common
    ../modules
  ];

  # Dynamic configuration from host
  home.username = osConfig.myConfig.username;
  home.homeDirectory = "/home/${osConfig.myConfig.username}";

  # State version should match the NixOS release when home-manager was first used
  # Read from host config
  home.stateVersion = osConfig.system.stateVersion;

  # Mirror system configuration to home-manager modules
  # This allows the new home-manager modules to access the same settings
  myConfig = {
    # Development tools - mirror from system config
    development.rust.enable = osConfig.myConfig.development.rust.enable or false;
    development.rust.includeNightly = osConfig.myConfig.development.rust.includeNightly or false;
    development.nodejs.enable = osConfig.myConfig.development.nodejs.enable or false;
    development.go.enable = osConfig.myConfig.development.go.enable or false;
    development.python.enable = osConfig.myConfig.development.python.enable or false;
    development.android.enable = osConfig.myConfig.development.android.enable or false;
    development.zig.enable = osConfig.myConfig.development.zig.enable or false;
    development.openssl.enable = osConfig.myConfig.development.openssl.enable or false;

    # DevOps tools
    devops.kubernetes.enable = osConfig.myConfig.development.devops.enable or false;
    devops.cloud.enable = osConfig.myConfig.development.devops.enable or false;
    devops.infrastructure.enable = osConfig.myConfig.development.devops.enable or false;

    # Shell
    shell.fish.enable = osConfig.myConfig.shell.fish.enable or false;
    shell.git.enable = osConfig.myConfig.shell.git.enable or false;
    shell.ssh.enable = osConfig.myConfig.shell.ssh.enable or false;

    # Editors
    editors.neovim.enable = osConfig.myConfig.editors.neovim.enable or false;
    editors.neovim.useNightly = osConfig.myConfig.editors.neovim.useNightly or false;

    # CLI tools - mirror from system config
    cliTools.terminals = {
      tmux.enable = osConfig.myConfig.cliTools.terminals.tmux.enable or false;
      zellij.enable = osConfig.myConfig.cliTools.terminals.zellij.enable or false;
      wezterm.enable = osConfig.myConfig.cliTools.terminals.wezterm.enable or false;
      ghostty.enable = osConfig.myConfig.cliTools.terminals.ghostty.enable or false;
    };
    cliTools.monitoring = {
      bottom.enable = osConfig.myConfig.cliTools.monitoring.bottom.enable or false;
      htop.enable = osConfig.myConfig.cliTools.monitoring.htop.enable or false;
      ncdu.enable = osConfig.myConfig.cliTools.monitoring.ncdu.enable or false;
    };
    cliTools.fileTools = {
      fzf.enable = osConfig.myConfig.cliTools.fileTools.fzf.enable or false;
      ripgrep.enable = osConfig.myConfig.cliTools.fileTools.ripgrep.enable or false;
      fd.enable = osConfig.myConfig.cliTools.fileTools.fd.enable or false;
      unzip.enable = osConfig.myConfig.cliTools.fileTools.unzip.enable or false;
      zip.enable = osConfig.myConfig.cliTools.fileTools.zip.enable or false;
    };
    cliTools.formatters = {
      nixfmt.enable = osConfig.myConfig.cliTools.formatters.nixfmt.enable or false;
      eslint.enable = osConfig.myConfig.cliTools.formatters.eslint.enable or false;
      prettier.enable = osConfig.myConfig.cliTools.formatters.prettier.enable or false;
      taplo.enable = osConfig.myConfig.cliTools.formatters.taplo.enable or false;
    };
    cliTools.utilities = {
      direnv.enable = osConfig.myConfig.cliTools.utilities.direnv.enable or false;
      jq.enable = osConfig.myConfig.cliTools.utilities.jq.enable or false;
      parallel.enable = osConfig.myConfig.cliTools.utilities.parallel.enable or false;
      write-good.enable = osConfig.myConfig.cliTools.utilities.write-good.enable or false;
      cloc.enable = osConfig.myConfig.cliTools.utilities.cloc.enable or false;
      watchexec.enable = osConfig.myConfig.cliTools.utilities.watchexec.enable or false;
      lsof.enable = osConfig.myConfig.cliTools.utilities.lsof.enable or false;
      killall.enable = osConfig.myConfig.cliTools.utilities.killall.enable or false;
      nix-search.enable = osConfig.myConfig.cliTools.utilities.nix-search.enable or false;
      media = {
        ffmpeg.enable = osConfig.myConfig.cliTools.utilities.media.ffmpeg.enable or false;
        flac.enable = osConfig.myConfig.cliTools.utilities.media.flac.enable or false;
        mediainfo.enable = osConfig.myConfig.cliTools.utilities.media.mediainfo.enable or false;
      };
      opencode.enable = osConfig.myConfig.cliTools.utilities.opencode.enable or false;
    };

    # Desktop (only configs, compositor installed at system level)
    desktop.hyprland = {
      enable = osConfig.myConfig.desktop.hyprland.enable or false;
      # Host-specific configs (set by host if needed)
      monitorsConfig = osConfig.myConfig.desktop.hyprland.monitorsConfig or null;
      workspacesConfig = osConfig.myConfig.desktop.hyprland.workspacesConfig or null;
    };
    desktop.waybar.enable = osConfig.myConfig.desktop.waybar.enable or false;
  };

  # Pass inputs to modules that need them
  _module.args = {
    inherit inputs;
  };

  # NixOS-specific packages (minimal - just examples)
  home.packages = with pkgs; [
    # Add platform-specific packages here
  ];

  # NixOS-specific home files
  home.file = {
    ".config/systemd/user/tmux.service.d/override.conf".text = ''
      [Install]

      [Service]
      ExecStart=

      [Unit]
    '';
  };
}
