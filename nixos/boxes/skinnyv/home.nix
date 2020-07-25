{ config, pkgs, ... }:
{
  home.file.".config/i3/status.toml".source = ../../../.config/i3/status-single-bat.toml;

  imports = [
    ../../home-common.nix
    ../../programs/git.nix
    ../../gui.nix
    ../../i3/home.nix
  ];
}
