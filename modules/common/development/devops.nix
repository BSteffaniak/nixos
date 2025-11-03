{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myConfig.development.devops = {
    enable = mkEnableOption "DevOps tools (kubectl, docker, aws, etc)";
  };

  config = mkIf config.myConfig.development.devops.enable {
    environment.systemPackages = with pkgs; [
      awscli2
      aws-sam-cli
      kubectl
      kind
      krew
      cmctl
      doctl
      lazydocker
      stern
      opentofu
    ];
  };
}
