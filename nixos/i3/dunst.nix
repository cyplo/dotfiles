{ config, pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#93a1a1";
        separator_color = "#93a1a1";
      };

      low = {
        msg_urgency = "low";
        background = "#073642";
        foreground = "#657b83";
      };

      normal = {
        msg_urgency = "normal";
        background = "#586e75";
        foreground = "#93a1a1";
      };

      critical = {
        msg_urgency = "critical";
        background = "#dc322f";
        foreground = "#eee8d5";
      };
    };
  };
}
