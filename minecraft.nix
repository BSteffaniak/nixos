{ pkgs }:

let
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
in
{
  inherit geyserMC;
  inherit floodgate;
  inherit viaVersion;
}
