{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./packages.nix
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
