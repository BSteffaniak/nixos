{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.cliTools.fileTools;
in
{
  options.myConfig.cliTools.fileTools = {
    fzf.enable = mkEnableOption "Fuzzy finder";
    ripgrep.enable = mkEnableOption "Ripgrep search tool";
    fd.enable = mkEnableOption "Fd file finder";
    unzip.enable = mkEnableOption "Unzip utility";
    zip.enable = mkEnableOption "Zip utility";
  };

  config = {
    environment.systemPackages = mkMerge [
      (mkIf cfg.fzf.enable [ pkgs.fzf ])
      (mkIf cfg.ripgrep.enable [ pkgs.ripgrep ])
      (mkIf cfg.fd.enable [ pkgs.fd ])
      (mkIf cfg.unzip.enable [ pkgs.unzip ])
      (mkIf cfg.zip.enable [ pkgs.zip ])
    ];
  };
}
