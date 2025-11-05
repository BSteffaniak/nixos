{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./fish.nix
    ./git.nix
    ./ssh.nix
  ];

  options.myConfig.shell = {
    enable = lib.mkEnableOption "Shell configuration";
  };
}
