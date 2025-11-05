{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.nodejs = {
    enable = mkEnableOption "Node.js development environment";
  };

  config = mkIf config.myConfig.development.nodejs.enable {
    environment.systemPackages = with pkgs; [
      nodePackages_latest.nodejs
      pnpm_10
      unstable.bun

      # Web development language servers
      typescript-language-server
      astro-language-server
      svelte-language-server
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint
    ];
  };
}
