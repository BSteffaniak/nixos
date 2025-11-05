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
        lua-language-server # Lua language server
        black # Python code formatter
        isort # Python import sorter
        pyright # Python type checker
        fsautocomplete # (FSAC) F# code completion/LSP
        buf # Protocol buffer (Protobuf) code completion/LSP
        clang-tools # C/C++ code completion/LSP
        bash-language-server # Bash language server
        astro-language-server # Astro language server
        beamMinimal27Packages.elixir-ls # Elixir language server
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers
        kotlin-language-server # Kotlin language server
        nil # Nix language server
        svelte-language-server # Svelte language server
        terraform-ls # Terraform language server
        typescript-language-server # TypeScript language server
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
