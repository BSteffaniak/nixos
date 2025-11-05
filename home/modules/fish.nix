{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.homeModules.fish = {
    enable = mkEnableOption "Fish shell configuration";

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Fish shell aliases";
      example = literalExpression ''
        {
          ll = "ls -la";
          gs = "git status";
          gd = "git diff";
        }
      '';
    };

    functions = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Fish shell functions";
      example = literalExpression ''
        {
          mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
        }
      '';
    };

    shellInit = mkOption {
      type = types.lines;
      default = "";
      description = "Shell initialization code (runs for all shells)";
    };

    interactiveShellInit = mkOption {
      type = types.lines;
      default = "";
      description = "Interactive shell initialization code";
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Fish plugins to install";
      example = literalExpression ''
        with pkgs.fishPlugins; [
          done
          fzf-fish
          forgit
          hydro
        ]
      '';
    };

    extraConfigFiles = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of additional fish config files to source.
        Paths are relative to home directory.
        Useful for sourcing non-Nix managed configurations.
        Files are sourced in order, and only if they exist.
      '';
      example = literalExpression ''
        [
          ".config/fish/work.fish"
          ".config/fish/private.fish"
          ".local/fish/custom.fish"
        ]
      '';
    };
  };

  config = mkIf config.homeModules.fish.enable {
    programs.fish = {
      enable = true;
      shellAliases = config.homeModules.fish.aliases;
      functions = config.homeModules.fish.functions;
      plugins = map (pkg: {
        name = pkg.pname;
        src = pkg.src;
      }) config.homeModules.fish.plugins;

      shellInit = ''
        ${config.homeModules.fish.shellInit}
      '';

      interactiveShellInit = ''
        # Source home-manager session variables using bass
        # This enables home.sessionPath and home.sessionVariables to work
        if test -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          bass source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        end

        # Source NixOS system environment variables
        if test -e /etc/set-environment
          bass source /etc/set-environment
        end

        # Source extra config files specified in configuration
        ${concatMapStringsSep "\n" (file: ''
          if test -e "$HOME/${file}"
            source "$HOME/${file}"
          end
        '') config.homeModules.fish.extraConfigFiles}

        # Source local override file (convention-based)
        # This allows quick customizations without rebuilding
        if test -e "$HOME/.config/fish/local.fish"
          source "$HOME/.config/fish/local.fish"
        end

        ${config.homeModules.fish.interactiveShellInit}
      '';
    };
  };
}
