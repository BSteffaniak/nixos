{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.shell.fish = {
    enable = mkEnableOption "Fish shell";
  };

  config = mkIf config.myConfig.shell.fish.enable {
    # Enable fish shell at system level (required for login shells on NixOS)
    # This just enables fish as a valid shell - user config is in home-manager
    programs.fish.enable = true;

    # Install Fish shell and required plugins at system level
    # Per-user configuration is handled by home-manager (see home/modules/fish.nix)
    environment.systemPackages = with pkgs; [
      python3
      fishPlugins.bass
    ];
  };
}
