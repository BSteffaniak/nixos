{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  config = mkIf (config.myConfig.shell.ssh.enable && config.myConfig.shell.ssh.server.enable) {
    # On macOS, we configure the system ssh daemon via nix-darwin
    services.openssh = {
      enable = true;
    };
  };
}
