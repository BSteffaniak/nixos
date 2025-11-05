# Personal home-manager overrides for nixos-desktop host
# Contains personal preferences and should not be copied when bootstrapping new hosts
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable GTK theming with personal preferences
  homeModules.gtkTheming = {
    enable = true;
    theme = "Juno";
    themePackage = pkgs.juno-theme;
    iconTheme = "Papirus-Dark";
    iconThemePackage = pkgs.papirus-icon-theme;
    cursorTheme = "Bibata-Modern-Classic";
    cursorThemePackage = pkgs.bibata-cursors;
    font = {
      name = "TeX Gyre Adventor";
      size = 10;
    };
  };

  # Fish shell configuration
  homeModules.fish = {
    functions = {
      # General utility functions
      reload-session = ''
        source ~/.config/fish/config.fish
      '';

      devship = ''
        airship --use-links $argv
      '';

      nvims = ''
        nvim -c 'lua Handle_load_session()' $argv
      '';

      man = ''
        command man $argv 2>/dev/null | col -b | nvim -R -c 'set ft=man nomod nolist' -
      '';

      fish_remove_path = ''
        if set -l index (contains -i "$argv" $fish_user_paths)
          set -e fish_user_paths[$index]
          echo "Removed $argv from the path"
        end
      '';

      # Flat logging functions
      set-flat-logging-levels = ''
        set -gx LOGGING_LABEL_LOGGING_LEVELS $argv[1]
      '';

      enable-flat-logging = ''
        set level $argv[1]
        set show_prefix $argv[2]
        set prefix_separator $argv[3]
        set suffix $argv[4]

        test -z "$level"; and set level DEBUG
        test -z "$show_prefix"; and set show_prefix true
        test -z "$prefix_separator"; and set prefix_separator '\n'
        test -z "$suffix"; and set suffix '\n'

        set-flat-logging-levels "*:$level"
        set -gx LOGGING_DEFAULT_SHOW_PREFIX $show_prefix
        set -gx LOGGING_DEFAULT_PREFIX_SEPARATOR $prefix_separator
        set -gx LOGGING_DEFAULT_SUFFIX $suffix
      '';

      disable-flat-logging = ''
        set -e LOGGING_LABEL_LOGGING_LEVELS
        set -e LOGGING_DEFAULT_SHOW_PREFIX
        set -e LOGGING_DEFAULT_PREFIX_SEPARATOR
        set -e LOGGING_DEFAULT_SUFFIX
      '';

      reset-flat-logging = ''
        disable-flat-logging
        enable-flat-logging
      '';

      # Development & testing functions
      benchmark = ''
        for i in (seq 1 400000)
          echo -e '\r'
          echo -e "Iteration $i:\r"
          echo -e '\033[0K\033[1mBold\033[0m \033[7mInvert\033[0m \033[4mUnderline\033[0m'
          echo -e '\033[0K\033[1m\033[7m\033[4mBold & Invert & Underline\033[0m'
          echo
          echo -e '\033[0K\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
          echo -e '\033[0K\033[1m\033[4m\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
          echo
          echo -e '\033[0K\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
          echo -e '\033[0K\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
          echo
          echo -e '\033[0K\033[30m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
          echo -e '\033[0K\033[30m\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
        end
      '';

      auto-retry = ''
        set current_attempt 0
        set max_attempts $argv[1]
        set delay $argv[2]
        set cmd $argv[3..-1]

        while test $current_attempt -lt $max_attempts
          set current_attempt (math $current_attempt + 1)
          if eval $cmd
            return 0
          end
          echo "Failed at attempt $current_attempt/$max_attempts, retrying after {$delay}s"
          sleep $delay
        end

        return 1
      '';

      opencode-dev = ''
        bun run --conditions=development /hdd/GitHub/opencode/packages/opencode/src/index.ts $argv
      '';

      zresurrect = ''
        echo "Resurrecting zellij sessions..."
        zellij list-sessions --short | while read session
          if test -n "$session"
            echo "→ $session"
            zellij attach $session --force-run-commands --create-background
          end
        end
        echo "Done! Check sessions with: zellij ls"
      '';
    };

    interactiveShellInit = ''
      # Set editor environment variables
      set -gx EDITOR nvim
      set -gx VISUAL nvim

      # Initialize direnv for per-directory environment management
      direnv hook fish | source
    '';
  };

  # Session variables (for cross-shell compatibility)
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Personal packages
  home.packages = with pkgs; [
    steam
  ];
}
