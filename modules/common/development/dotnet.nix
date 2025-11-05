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

    # SDK or Runtime-only mode
    runtimeOnly = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Install only the .NET runtime without SDK.
        If true, sdkVersions will be ignored and runtimeVersions will be used instead.
      '';
    };

    sdkVersions = mkOption {
      type = types.listOf (
        types.enum [
          "6"
          "7"
          "8"
          "9"
          "10"
        ]
      );
      default = [ ];
      description = ''
        List of .NET SDK versions to install.
        Empty list defaults to latest stable (8).
        Multiple versions will be combined into a single package.
      '';
      example = [
        "8"
        "9"
      ];
    };

    runtimeVersions = mkOption {
      type = types.listOf (
        types.enum [
          "6"
          "7"
          "8"
          "9"
          "10"
        ]
      );
      default = [ ];
      description = ''
        List of .NET runtime versions to install (when runtimeOnly = true).
        Empty list defaults to latest stable (8).
      '';
      example = [
        "8"
        "9"
      ];
    };

    # ASP.NET Core support
    aspnetcore = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Install ASP.NET Core runtime (separate from SDK)";
      };

      versions = mkOption {
        type = types.listOf (
          types.enum [
            "8"
            "9"
            "10"
          ]
        );
        default = [ ];
        description = "ASP.NET Core runtime versions. Empty defaults to latest (8).";
        example = [
          "8"
          "9"
        ];
      };
    };

    # Entity Framework Core
    entityFramework = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install Entity Framework Core tools (dotnet-ef)";
      };
    };

    # Global Tools
    globalTools = {
      enableOutdated = mkOption {
        type = types.bool;
        default = false;
        description = "Install dotnet-outdated for checking outdated dependencies";
      };

      enableRepl = mkOption {
        type = types.bool;
        default = false;
        description = "Install dotnet-repl for interactive C# REPL";
      };

      enableFormatters = mkOption {
        type = types.bool;
        default = false;
        description = "Install code formatters (CSharpier, Fantomas for F#)";
      };

      enablePaket = mkOption {
        type = types.bool;
        default = false;
        description = "Install Paket dependency manager";
      };
    };

    # NuGet Configuration
    nuget = {
      enableCustomSources = mkOption {
        type = types.bool;
        default = false;
        description = "Enable custom NuGet source configuration";
      };

      sources = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Custom NuGet package sources.
          Attribute names are source names, values are URLs.
        '';
        example = {
          "myget" = "https://www.myget.org/F/my-feed/api/v3/index.json";
          "github" = "https://nuget.pkg.github.com/myorg/index.json";
        };
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to custom NuGet.Config file";
      };
    };

    # Telemetry and CLI Experience
    telemetry = {
      optOut = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Disable .NET CLI telemetry collection.
          Sets DOTNET_CLI_TELEMETRY_OPTOUT=1 when true.
          Microsoft collects usage data by default; this opts out.
        '';
      };

      skipFirstTimeExperience = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Skip first-run experience messages and prompts.
          Sets DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 when true.
          Useful for automated environments and CI/CD.
        '';
      };

      disableLogo = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Disable .NET logo display in CLI output.
          Sets DOTNET_NOLOGO=1 when true.
          Reduces visual noise in terminal output.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Assert that runtimeOnly and sdkVersions are not both configured
    assertions = [
      {
        assertion = !(cfg.runtimeOnly && cfg.sdkVersions != [ ]);
        message = "Cannot specify sdkVersions when runtimeOnly is true. Use runtimeVersions instead.";
      }
    ];

    environment.systemPackages =
      with pkgs;
      let
        # SDK version mapping
        sdkMap = {
          "6" = dotnet-sdk_6;
          "7" = dotnet-sdk_7;
          "8" = dotnet-sdk_8;
          "9" = dotnet-sdk_9;
          "10" = dotnet-sdk_10;
        };

        # Runtime version mapping
        runtimeMap = {
          "6" = dotnet-runtime_6;
          "7" = dotnet-runtime_7;
          "8" = dotnet-runtime_8;
          "9" = dotnet-runtime_9;
          "10" = dotnet-runtime_10;
        };

        # ASP.NET Core version mapping
        aspnetcoreMap = {
          "8" = dotnet-aspnetcore_8;
          "9" = dotnet-aspnetcore_9;
          "10" = dotnet-aspnetcore_10;
        };

        # Get selected packages or default to latest
        selectedSdks =
          if cfg.sdkVersions == [ ] then
            [ dotnet-sdk ] # Latest stable (8.x)
          else
            map (v: sdkMap.${v}) cfg.sdkVersions;

        selectedRuntimes =
          if cfg.runtimeVersions == [ ] then
            [ dotnet-runtime ] # Latest stable (8.x)
          else
            map (v: runtimeMap.${v}) cfg.runtimeVersions;

        selectedAspnetcore =
          if cfg.aspnetcore.versions == [ ] then
            [ dotnet-aspnetcore ] # Latest stable (8.x)
          else
            map (v: aspnetcoreMap.${v}) cfg.aspnetcore.versions;

        # Combine multiple SDKs/Runtimes if needed
        combinedSdk =
          if length selectedSdks > 1 then
            dotnetCorePackages.combinePackages selectedSdks
          else
            head selectedSdks;

        combinedRuntime =
          if length selectedRuntimes > 1 then
            dotnetCorePackages.combinePackages selectedRuntimes
          else
            head selectedRuntimes;

        # Choose SDK or Runtime-only
        dotnetPackage = if cfg.runtimeOnly then combinedRuntime else combinedSdk;

        # ASP.NET Core packages
        aspnetcorePackages = optionals cfg.aspnetcore.enable selectedAspnetcore;

        # Entity Framework
        efPackages = optional cfg.entityFramework.enable dotnet-ef;

        # Global tools
        globalToolPackages =
          (optional cfg.globalTools.enableOutdated dotnet-outdated)
          ++ (optional cfg.globalTools.enableRepl dotnet-repl)
          ++ (optionals cfg.globalTools.enableFormatters [
            pkgs.csharpier
            pkgs.fantomas
          ])
          ++ (optional cfg.globalTools.enablePaket pkgs.dotnetPackages.Paket);

      in
      [ dotnetPackage ] ++ aspnetcorePackages ++ efPackages ++ globalToolPackages;

    # NuGet configuration
    environment.etc."nuget/NuGet.Config" = mkIf cfg.nuget.enableCustomSources (
      if cfg.nuget.configFile != null then
        { source = cfg.nuget.configFile; }
      else
        {
          text = ''
            <?xml version="1.0" encoding="utf-8"?>
            <configuration>
              <packageSources>
                <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
                ${concatStringsSep "\n    " (
                  mapAttrsToList (
                    name: url: ''<add key="${name}" value="${url}" protocolVersion="3" />''
                  ) cfg.nuget.sources
                )}
              </packageSources>
            </configuration>
          '';
        }
    );

    # Telemetry and CLI environment configuration
    environment.variables = mkMerge [
      (mkIf cfg.telemetry.optOut {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      })
      (mkIf cfg.telemetry.skipFirstTimeExperience {
        DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
      })
      (mkIf cfg.telemetry.disableLogo {
        DOTNET_NOLOGO = "1";
      })
    ];
  };
}
