{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.java = {
    enable = mkEnableOption "Java development environment";
  };

  config = mkIf config.myConfig.development.java.enable {
    environment.systemPackages = with pkgs; [
      maven
      kotlin-language-server # Kotlin LSP
    ];
  };
}
