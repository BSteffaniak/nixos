{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    userName = "Braden Steffaniak";
    userEmail = "BradenSteffaniak@gmail.com";
  };
}
