{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.openssl = {
    enable = mkEnableOption "OpenSSL development environment";
  };

  config = mkIf config.myConfig.development.openssl.enable {
    environment.systemPackages = with pkgs; [
      pkg-config
      openssl
      openssl.dev
    ];

    environment.variables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };
  };
}
