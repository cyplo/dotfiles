{ config, pkgs, ... }:
{
  home.sessionVariables = {
    TERMINAL="kitty";
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_size = "16.0";
      font_family      = "FiraCode Nerd Font";
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";
      background = "#001e26";
      foreground = "#708183";
      selection_foreground ="#001e26";
      selection_background = "#002731";
      cursor = "#708183";

      color0  = "#002731";
      color1  = "#d01b24";
      color2  = "#728905";
      color3  = "#a57705";
      color4  = "#2075c7";
      color5  = "#c61b6e";
      color6  = "#259185";
      color7  = "#e9e2cb";
      color8  = "#001e26";
      color9  = "#bd3612";
      color10 = "#465a61";
      color11 = "#52676f";
      color12 = "#708183";
      color13 = "#5856b9";
      color14 = "#81908f";
      color15 = "#fcf4dc";

    };
  };
}
