{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./networking.nix
    ./security.nix
    ./audio.nix
    ./locale.nix
  ];

  options.myConfig.system = {
    enable = lib.mkEnableOption "System configuration";
  };

  config = mkIf config.myConfig.system.enable {
    systemd.user.services.tmux = {
      enable = false;
    };
  };
}
