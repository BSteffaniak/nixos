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

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}
