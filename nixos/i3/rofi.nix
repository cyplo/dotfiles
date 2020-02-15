{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    font = "Fira Code 12";
    separator = "solid";
    scrollbar = false;
    theme = "solarized";
  };
}
