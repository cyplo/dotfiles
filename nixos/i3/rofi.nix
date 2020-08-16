{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    font = "Fira Code Nerd Font 16";
    separator = "solid";
    scrollbar = false;
    theme = "solarized";
  };
}
