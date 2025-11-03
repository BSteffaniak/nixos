{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  minecraftData = {
    geyserMC = pkgs.fetchurl {
      url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot";
      hash = "sha256-1w5Iy8DkpbQds1Ha6r+rOQGJ/KVit3PmIBJvhNqOWGE=";
    };
    floodgate = pkgs.fetchurl {
      url = "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot";
      hash = "sha256-AelUlBDvIOJk75r2tDxp89HPJOl1b/9mc4KgScPKjTk=";
    };
    viaVersion = pkgs.fetchurl {
      url = "https://github.com/ViaVersion/ViaVersion/releases/tag/5.4.2/download/ViaVersion-5.4.2.jar";
      hash = "sha256-i/wiKjWnaMQjNZ8VByNtrbPD80WRWRueIMoSOCWN8TU=";
    };
  };
in
{
  options.myConfig.services.minecraft = {
    enable = mkEnableOption "Minecraft server";
  };

  config = mkIf config.myConfig.services.minecraft.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      servers = {
        greenfield = {
          enable = true;
          autoStart = false;

          # Use Paper server
          package = pkgs.paperServers.paper;

          serverProperties = {
            server-port = 25565;
            max-players = 20;
            view-distance = 10;
            simulation-distance = 10;
            enable-command-block = true;
            motd = "Greenfield - Java & Bedrock Crossplay";
            resource-pack-required = true;
          };

          whitelist = {
            # Your whitelist entries here
          };

          symlinks = {
            "plugins/GeyserMC.jar" = minecraftData.geyserMC;
            "plugins/Floodgate.jar" = minecraftData.floodgate;
            "plugins/ViaVersion.jar" = minecraftData.viaVersion;
          };
        };
      };
    };

    # Open Bedrock port
    networking.firewall.allowedUDPPorts = [ 19132 ];
  };
}
