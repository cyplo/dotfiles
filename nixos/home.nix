{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    firefox.enable = true;
    chromium.enable = true;
    alacritty.enable = true;
    zsh.enable = true;
    go.enable = true;
  };
}
