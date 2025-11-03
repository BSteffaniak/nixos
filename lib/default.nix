{ lib, ... }:

{
  # Helper to check if we're on Darwin
  isDarwin = system: lib.hasSuffix "-darwin" system;

  # Helper to check if we're on Linux
  isLinux = system: lib.hasSuffix "-linux" system;

  # Helper to conditionally include packages based on platform
  optionalPkgs = condition: pkgs: if condition then pkgs else [ ];
}
