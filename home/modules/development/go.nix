{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.go;
in
{
  options.myConfig.development.go = {
    enable = mkEnableOption "Go development environment";

    includeLSP = mkOption {
      type = types.bool;
      default = true;
      description = "Include gopls (Go language server)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ go ] ++ (optional cfg.includeLSP gopls);

    # Set up Go environment variables
    home.sessionVariables = {
      GOPATH = "$HOME/go";
      GOBIN = "$HOME/go/bin";
    };

    # Add GOBIN to PATH
    home.sessionPath = [ "$HOME/go/bin" ];
  };
}
