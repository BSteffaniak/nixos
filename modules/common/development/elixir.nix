{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.elixir = {
    enable = mkEnableOption "Elixir development environment";
  };

  config = mkIf config.myConfig.development.elixir.enable {
    environment.systemPackages = with pkgs; [
      elixir
      beamMinimal27Packages.elixir-ls # Elixir LSP
    ];
  };
}
