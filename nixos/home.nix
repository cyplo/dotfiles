{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    zsh = { 
      enable = true;
      history.share = true;
      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
      };
    };
    firefox.enable = true;
    chromium.enable = true;
    alacritty.enable = true;
    go.enable = true;
    bat.enable = true;
  };
}
