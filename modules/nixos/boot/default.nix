{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.boot = {
    enable = mkEnableOption "Boot configuration";
    useLatestKernel = mkOption {
      type = types.bool;
      default = false;
      description = "Use latest kernel instead of stable";
    };
  };

  config = mkIf config.myConfig.boot.enable {
    boot = {
      kernelPackages =
        if config.myConfig.boot.useLatestKernel then pkgs.linuxPackages_latest else pkgs.linuxPackages;

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        grub.configurationLimit = 5;
      };

      extraModulePackages = [ ];
      kernelModules = [ ];
      initrd.kernelModules = [ ];

      # AppImage support
      binfmt.registrations.appimage = {
        wrapInterpreterInShell = false;
        interpreter = "${pkgs.appimage-run}/bin/appimage-run";
        recognitionType = "magic";
        offset = 0;
        mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
        magicOrExtension = ''\x7fELF....AI\x02'';
      };
    };

    environment.systemPackages = with pkgs; [
      appimage-run
    ];
  };
}
