{
  config,
  lib,
  pkgs,
  inputs ? { },
  ...
}:

with lib;

let
  cfg = config.myConfig.editors.neovim;
in
{
  options.myConfig.editors.neovim = {
    enable = mkEnableOption "Neovim editor";

    useNightly = mkOption {
      type = types.bool;
      default = false;
      description = "Use nightly Neovim build";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        # Lua runtime and development tools
        # Note: Using luajit only (what Neovim uses) to avoid collision with lua package
        luajit
        luajitPackages.luarocks

        # Neovim configuration editing tools
        stylua
        lua-language-server

        # Universal language servers
        nil # Nix LSP
        bash-language-server
      ]
      ++ (
        # Neovim editor (conditional: nightly or stable)
        if cfg.useNightly && inputs ? neovim-nightly-overlay then
          [ inputs.neovim-nightly-overlay.packages."${pkgs.system}".default ]
        else
          [ pkgs.neovim ]
      );

    # Set neovim as default editor
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Symlink standalone neovim config from configs/neovim
    xdg.configFile."nvim" = {
      source = ../../../configs/neovim;
      recursive = true;
    };

    # Enable the fish neovim integration if fish is enabled
    homeModules.fish.neovim.enable = mkIf config.programs.fish.enable true;
  };
}
