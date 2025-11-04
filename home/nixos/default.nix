{
  config,
  lib,
  pkgs,
  osConfig,
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
