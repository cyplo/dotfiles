{ config, pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    userName = "Cyryl Płotnicki";
    userEmail = "cyplo@cyplo.net";
    includes = [
      { path =    "../.gitconfig.linux.private"; }
    ];
  };
}
