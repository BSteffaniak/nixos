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
      with pkgs;
      [
        # Lua runtime and development tools
        lua # Standard Lua interpreter (5.x)
        luajit # LuaJIT - faster JIT compiler (what Neovim uses)
        luajitPackages.luarocks # Lua package manager
        stylua # Lua code formatter
      ]
      ++ (
        # Neovim editor (conditional: nightly or stable)
        if config.myConfig.editors.neovim.useNightly then
          [ inputs.neovim-nightly-overlay.packages."${pkgs.system}".default ]
        else
          [ pkgs.neovim ]
      );
  };
}
