{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.elixir;
in
{
  options.myConfig.development.elixir = {
    enable = mkEnableOption "Elixir development environment";

    includeLSP = mkOption {
      type = types.bool;
      default = true;
      description = "Include Elixir language server";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        elixir
      ]
      ++ (optional cfg.includeLSP beamMinimal27Packages.elixir-ls);
  };
}
