{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.homeModules.git = {
    enable = mkEnableOption "Git configuration";

    userName = mkOption {
      type = types.str;
      default = "Braden Steffaniak";
      description = "Git user name";
    };

    userEmail = mkOption {
      type = types.str;
      default = "BradenSteffaniak@gmail.com";
      description = "Git user email";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {
        pull.rebase = true;
        core.autocrlf = "input";
      };
      description = "Additional git configuration";
      example = literalExpression ''
        {
          pull.rebase = true;
          core.autocrlf = "input";
          init.defaultBranch = "main";
          commit.gpgsign = true;
        }
      '';
    };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Git aliases";
      example = literalExpression ''
        {
          co = "checkout";
          br = "branch";
          st = "status";
          lg = "log --graph --oneline --decorate";
        }
      '';
    };

    signing = {
      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "GPG key ID for signing commits";
      };

      signByDefault = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to sign commits by default";
      };
    };
  };

  config = mkIf config.homeModules.git.enable {
    programs.git = {
      enable = true;
      userName = config.homeModules.git.userName;
      userEmail = config.homeModules.git.userEmail;
      extraConfig = config.homeModules.git.extraConfig;
      aliases = config.homeModules.git.aliases;
      signing = mkIf (config.homeModules.git.signing.key != null) {
        key = config.homeModules.git.signing.key;
        signByDefault = config.homeModules.git.signing.signByDefault;
      };
    };
  };
}
