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
    extraConfig = {
      pull.rebase = true;
      core.autocrlf = "input";
    };
  };
}
