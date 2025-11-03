{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.system.networking = {
    enable = mkEnableOption "Networking configuration";
    hostName = mkOption {
      type = types.str;
      default = "nixos";
      description = "System hostname";
    };
    enableSSH = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SSH server";
    };
    allowedTCPPorts = mkOption {
      type = types.listOf types.int;
      default = [ ];
      description = "Additional TCP ports to open";
    };
    allowedUDPPorts = mkOption {
      type = types.listOf types.int;
      default = [ ];
      description = "Additional UDP ports to open";
    };
  };

  config = mkIf config.myConfig.system.networking.enable {
    networking = {
      hostName = config.myConfig.system.networking.hostName;
      networkmanager.enable = true;

      firewall = {
        enable = true;
        allowedTCPPorts = [
          3000
          3131
          8000
          8086
          8343
          8344
        ]
        ++ config.myConfig.system.networking.allowedTCPPorts;
        allowedUDPPorts = config.myConfig.system.networking.allowedUDPPorts;
      };
    };

    environment.systemPackages = with pkgs; [
      networkmanager
      networkmanagerapplet
      wirelesstools
    ];

    services.openssh = mkIf config.myConfig.system.networking.enableSSH {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ config.myConfig.username ];
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    services.printing.enable = true;
  };
}
