{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.development.openssl;
in
{
  options.myConfig.development.openssl = {
    enable = mkEnableOption "OpenSSL development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pkg-config
      openssl
      openssl.dev
    ];

    home.sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };
  };
}
