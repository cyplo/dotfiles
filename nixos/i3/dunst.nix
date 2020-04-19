{ config, pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Fira Code Nerd Font 10";
        sort = "yes";
        indicate_hidden = "yes";
        word_wrap = "yes";
        stack_duplicates = "yes";
        hide_duplicates_count = "yes";
        geometry = "300x50-15+49";
        shrink = "no";
        transparency = 5;
        line_height = 3;
        padding = 6;
        horizontal_padding = 6;
        separator_color = "frame";
        icon_position = "off";
        max_icon_size = 80;
        frame_width = 3;
        frame_color = "#8EC07C";
      };

      low = {
        msg_urgency = "low";
        frame_color = "#3B7C87";
        foreground = "#3B7C87";
        background = "#191311";
        timeout = 5;
      };

      normal = {
        msg_urgency = "normal";
        frame_color = "#5B8234";
        foreground = "#5B8234";
        background = "#191311";
        timeout = 8;
      };

      critical = {
        msg_urgency = "critical";
        frame_color = "#B7472A";
        foreground = "#B7472A";
        background = "#191311";
        timeout = 15;
      };
    };
  };
}
