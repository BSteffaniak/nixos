{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.python = {
    enable = mkEnableOption "Python development environment";
  };

  config = mkIf config.myConfig.development.python.enable {
    environment.systemPackages = with pkgs; [
      python3

      # Python development tools
      black # Python code formatter
      isort # Python import sorter
      pyright # Python type checker/LSP
    ];
  };
}
