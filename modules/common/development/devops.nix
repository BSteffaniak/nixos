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
      kubernetes-helm-wrapped
      krew
      cmctl
      doctl
      lazydocker
      stern
      opentofu

      # Infrastructure language servers
      terraform-ls # Terraform LSP
      buf # Protocol buffer (Protobuf) LSP
    ];
  };
}
