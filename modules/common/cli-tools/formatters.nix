{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.formatters;
in
{
  options.myConfig.cliTools.formatters = {
    nixfmt.enable = mkEnableOption "Nix formatter (nixfmt-rfc-style)";
    eslint.enable = mkEnableOption "ESLint daemon";
    prettier.enable = mkEnableOption "Prettier daemon";
    taplo.enable = mkEnableOption "TOML formatter";
  };

  config = {
    environment.systemPackages = mkMerge [
      (mkIf cfg.nixfmt.enable [ pkgs.nixfmt-rfc-style ])
      (mkIf cfg.eslint.enable [ pkgs.eslint_d ])
      (mkIf cfg.prettier.enable [ pkgs.prettierd ])
      (mkIf cfg.taplo.enable [ pkgs.taplo ])
    ];
  };
}
