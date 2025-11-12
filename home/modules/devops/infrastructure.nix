{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myConfig.devops.infrastructure;
in
{
  options.myConfig.devops.infrastructure = {
    enable = mkEnableOption "Infrastructure as Code tools";

    includeTerraform = mkOption {
      type = types.bool;
      default = true;
      description = "Include OpenTofu (Terraform fork)";
    };

    includeTerraformLS = mkOption {
      type = types.bool;
      default = true;
      description = "Include Terraform Language Server";
    };

    includeProtobuf = mkOption {
      type = types.bool;
      default = true;
      description = "Include buf (Protocol buffer tooling)";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ ]
      ++ (optional cfg.includeTerraform opentofu)
      ++ (optional cfg.includeTerraformLS terraform-ls)
      ++ (optional cfg.includeProtobuf buf);

    # Terraform/OpenTofu aliases
    programs.fish.interactiveShellInit = mkIf (config.programs.fish.enable && cfg.includeTerraform) ''
      # Terraform/OpenTofu aliases
      alias tf='tofu'
      alias tfi='tofu init'
      alias tfp='tofu plan'
      alias tfa='tofu apply'
      alias tfd='tofu destroy'
    '';
  };
}
