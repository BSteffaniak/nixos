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
    programs.fish = {
      enable = true;

      # Auto-source NixOS environment on shell start
      # Bass is auto-loaded from systemPackages
      interactiveShellInit = ''
        # Source NixOS system environment variables
        if test -e /etc/set-environment
          bass source /etc/set-environment
        end
      '';
    };

    # Install bass plugin - Fish automatically discovers it
    environment.systemPackages = with pkgs; [
      fishPlugins.bass
    ];
  };
}
