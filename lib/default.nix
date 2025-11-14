{ lib, ... }:

{
  # Helper to check if we're on Darwin
  isDarwin = system: lib.hasSuffix "-darwin" system;

  # Helper to check if we're on Linux
  isLinux = system: lib.hasSuffix "-linux" system;

  # Helper to conditionally include packages based on platform
  optionalPkgs = condition: pkgs: if condition then pkgs else [ ];

  # Helper for enable options with a custom default value
  # Usage: mkEnableOption' cfg.enableAll "Description of the feature"
  mkEnableOption' =
    defaultValue: description:
    lib.mkOption {
      type = lib.types.bool;
      default = defaultValue;
      description = "Enable ${description}";
    };
}
