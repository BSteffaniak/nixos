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
      openssl
    ];

    environment.variables = mkIf pkgs.stdenv.isDarwin {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };
  };
}
