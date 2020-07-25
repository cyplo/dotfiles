{ config, pkgs, ... }:

{
  home.file.".config/i3/status.toml".source = ../../../.config/i3/status-double-bat.toml;

  imports = [
    ../../home-common.nix
    ../../programs/git.nix
    ../../gui.nix
    ../../gnome/home.nix
  ];
}
