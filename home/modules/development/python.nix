{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.python;
in
{
  options.myConfig.development.python = {
    enable = mkEnableOption "Python development environment";

    includeTools = mkOption {
      type = types.bool;
      default = true;
      description = "Include black, isort, and pyright";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        python3
      ]
      ++ (optionals cfg.includeTools [
        black # Python code formatter
        isort # Python import sorter
        pyright # Python type checker/LSP
      ]);

    # Python user site packages
    home.sessionVariables = {
      PYTHONUSERBASE = "$HOME/.local";
    };
  };
}
