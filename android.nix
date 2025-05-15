{ pkgs }:

pkgs.androidenv.composeAndroidPackages {
  cmdLineToolsVersion = "13.0";
  toolsVersion = "26.1.1";
  platformToolsVersion = "35.0.2";
  buildToolsVersions = [
    "30.0.3"
    "34.0.0"
  ];
  platformVersions = [
    "33"
    "34"
  ];
  includeEmulator = true;
  emulatorVersion = "35.2.5";
  includeSystemImages = true;
  systemImageTypes = [ "default" ];
  abiVersions = [
    "arm64-v8a"
    "armeabi-v7a"
    "x86"
    "x86_64"
  ];
  includeSources = false;
  includeNDK = true;
  useGoogleAPIs = false;
  useGoogleTVAddOns = false;
  includeExtras = [ ];
  extraLicenses = [ ];
}
