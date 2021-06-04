{ config, pkgs, ... }:
{
  programs.i3status= {
    enable = true;
    enableDefault = false;
    modules = {
      "memory" = {
        position = 2;
      };
      "disk /" = {
        position = 2;
        settings = {
          format = "/ %avail";
        };
      };
      "battery all" = {
        settings = {
          status_chr = "";
          status_bat = "";
          status_full = "";
          low_threshold = 30;
          threshold_type = "time";
        };
        position = 3;
      };
      "time" = {
        settings = {
          format = "%H:%M %a %d/%m";
        };
        position = 9;
      };
    };
  };

}
