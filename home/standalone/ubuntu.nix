# Ubuntu-specific tweaks and configurations
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Ubuntu-specific environment adjustments
  home.sessionVariables = {
    # Help Nix find locale on Ubuntu
    LOCALE_ARCHIVE = lib.mkIf (pkgs.stdenv.isLinux) "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  # Ubuntu typically uses systemd for user services
  systemd.user.startServices = "sd-switch";

  # Additional packages useful on Ubuntu
  home.packages = with pkgs; [
    # Tools to interact with Ubuntu's package system
    # (these are just viewers, won't interfere with apt)
  ];
}
