{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  config = mkMerge [
    # SSH client installation (NixOS needs the openssh package)
    (mkIf config.myConfig.shell.ssh.enable {
      environment.systemPackages = mkIf config.myConfig.shell.ssh.client.enable [
        pkgs.openssh
      ];
    })

    # SSH server configuration
    (mkIf (config.myConfig.shell.ssh.enable && config.myConfig.shell.ssh.server.enable) {
      services.openssh = {
        enable = true;
        ports = [ config.myConfig.shell.ssh.server.port ];
        settings = {
          PasswordAuthentication = config.myConfig.shell.ssh.server.passwordAuthentication;
          AllowUsers = config.myConfig.shell.ssh.server.allowedUsers;
          UseDns = config.myConfig.shell.ssh.server.useDns;
          X11Forwarding = config.myConfig.shell.ssh.server.x11Forwarding;
          PermitRootLogin = config.myConfig.shell.ssh.server.permitRootLogin;
        };
        extraConfig = config.myConfig.shell.ssh.server.extraConfig;
      };
    })
  ];
}
