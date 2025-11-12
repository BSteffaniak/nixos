{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.dotnet;
in
{
  options.myConfig.development.dotnet = {
    enable = mkEnableOption ".NET development environment";

    version = mkOption {
      type = types.enum [
        "6"
        "7"
        "8"
        "9"
        "10"
      ];
      default = "8";
      description = ".NET SDK version to install";
    };

    includeEntityFramework = mkOption {
      type = types.bool;
      default = true;
      description = "Include Entity Framework Core tools";
    };

    telemetryOptOut = mkOption {
      type = types.bool;
      default = true;
      description = "Disable .NET CLI telemetry collection";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      let
        sdkMap = {
          "6" = dotnet-sdk_6;
          "7" = dotnet-sdk_7;
          "8" = dotnet-sdk_8;
          "9" = dotnet-sdk_9;
          "10" = dotnet-sdk_10;
        };
        selectedSdk = sdkMap.${cfg.version};
      in
      [
        selectedSdk
        csharp-ls
        unstable.fsautocomplete
      ]
      ++ (optional cfg.includeEntityFramework dotnet-ef);

    home.sessionVariables = mkMerge [
      {
        DOTNET_ROOT = "\${HOME}/.dotnet";
      }
      (mkIf cfg.telemetryOptOut {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
      })
    ];
  };
}
