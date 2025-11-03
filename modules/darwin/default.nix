{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./homebrew.nix
    ./system-defaults.nix
    ./applications.nix
  ];

  config = {
    # Enable experimental features
    nix.settings.experimental-features = "nix-command flakes";

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Enable fish shell
    programs.fish.enable = true;
  };
}
