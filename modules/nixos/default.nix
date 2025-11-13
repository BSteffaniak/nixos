{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./boot
    ./hardware
    ./desktop
    ./services
    ./system
    ./cli-tools.nix
  ];

  config = {
    # Enable experimental features
    nix = {
      package = pkgs.nix;
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
