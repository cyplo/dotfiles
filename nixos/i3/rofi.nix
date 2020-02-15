{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    font = "Fira Code 12";
    separator = "solid";
    scrollbar = false;
    colors = {
      window = {
        background = "#002b36";
        border = "#073642";
        separator = "#002b36";
      };

      rows = {
        normal = {
          background = "#002b36";
          foreground = "#839496";
          backgroundAlt = "argb:58455a64";
          highlight = {
            background = "#002b36";
            foreground = "#fafbfc";
          };
        };
      };
    };
  };
}
