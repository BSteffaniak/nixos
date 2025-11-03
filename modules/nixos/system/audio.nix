{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.system.audio = {
    enable = mkEnableOption "Audio with PipeWire";
  };

  config = mkIf config.myConfig.system.audio.enable {
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      libopus
    ];
  };
}
