{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

{
  options.myConfig.editors.neovim = {
    enable = mkEnableOption "Neovim editor";
    useNightly = mkOption {
      type = types.bool;
      default = false;
      description = "Use nightly Neovim build";
    };
  };

  config = mkIf config.myConfig.editors.neovim.enable {
    environment.systemPackages =
      if config.myConfig.editors.neovim.useNightly then
        [ inputs.neovim-nightly-overlay.packages."${pkgs.system}".default ]
      else
        [ pkgs.neovim ];
  };
}
