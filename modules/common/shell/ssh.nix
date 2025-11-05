{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.shell.ssh = {
    enable = mkEnableOption "OpenSSH configuration";

    server = {
      enable = mkEnableOption "OpenSSH server (sshd)";

      port = mkOption {
        type = types.int;
        default = 22;
        description = "SSH server port";
      };

      allowedUsers = mkOption {
        type = types.listOf types.str;
        default = [ config.myConfig.username ];
        description = "Users allowed to connect via SSH";
      };

      passwordAuthentication = mkOption {
        type = types.bool;
        default = true;
        description = "Allow password authentication";
      };

      permitRootLogin = mkOption {
        type = types.enum [
          "yes"
          "no"
          "prohibit-password"
          "forced-commands-only"
        ];
        default = "prohibit-password";
        description = "Permit root login";
      };

      x11Forwarding = mkOption {
        type = types.bool;
        default = false;
        description = "Enable X11 forwarding";
      };

      useDns = mkOption {
        type = types.bool;
        default = true;
        description = "Use DNS for hostname resolution";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra SSH server configuration";
      };
    };

    client = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install SSH client tools";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra SSH client configuration (~/.ssh/config)";
      };
    };
  };
}
