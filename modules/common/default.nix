{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./development
    ./shell
    ./editors
    ./cli-tools
  ];

  # Common options available on all platforms
  options.myConfig = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "braden";
      description = "Primary username";
    };

    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Braden Steffaniak";
      description = "Full name for user";
    };
  };

  config = {
    # Common packages for all platforms
    environment.systemPackages = with pkgs; [
      vim
      wget
      clang
      glib
      ra-multiplex-latest
      nvd
    ];
  };
}
