{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.nodejs;
in
{
  options.myConfig.development.nodejs = {
    enable = mkEnableOption "Node.js development environment";

    includeBun = mkOption {
      type = types.bool;
      default = true;
      description = "Include Bun runtime";
    };

    includePnpm = mkOption {
      type = types.bool;
      default = true;
      description = "Include pnpm package manager";
    };

    includeLanguageServers = mkOption {
      type = types.bool;
      default = true;
      description = "Include TypeScript, Astro, Svelte, and web LSPs";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        nodePackages_latest.nodejs
      ]
      ++ (optional cfg.includeBun unstable.bun)
      ++ (optional cfg.includePnpm pnpm_10)
      ++ (optionals cfg.includeLanguageServers [
        typescript-language-server
        astro-language-server
        svelte-language-server
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      ]);

    # Configure npm to use global directory in home
    home.sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    # Add npm global bin to PATH
    home.sessionPath = [ "$HOME/.npm-global/bin" ];
  };
}
