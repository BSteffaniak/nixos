{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.go = {
    enable = mkEnableOption "Go development environment";
  };

  config = mkIf config.myConfig.development.go.enable {
    environment.systemPackages = with pkgs; [
      go
      gopls # Go LSP
    ];
  };
}
