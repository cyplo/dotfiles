{ config, pkgs, ... }:
{
  programs.termite = {
    enable = true;
    allowBold = true;
    audibleBell = false;
    clickableUrl = true;
    dynamicTitle = true;
    mouseAutohide = true;
    scrollOnKeystroke = false;
    font = "Fira Code 12";

    backgroundColor = "#002b36";
    foregroundColor = "#839496";
    colorsExtra = ''
      color0  = #073642
      color1  = #dc322f
      color2  = #859900
      color3  = #b58900
      color4  = #268bd2
      color5  = #d33682
      color6  = #2aa198
      color7  = #eee8d5
      color8  = #002b36
      color9  = #cb4b16
      color10 = #586e75
      color11 = #657b83
      color12 = #839496
      color13 = #6c71c4
      color14 = #93a1a1
      color15 = #fdf6e3

      color16 = #cb4b16
      color17 = #d33682
      color18 = #073642
      color19 = #586e75
      color20 = #839496
      color21 = #eee8d5
    '';
  };
}
