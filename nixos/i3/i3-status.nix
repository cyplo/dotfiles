{ config, pkgs, ... }:
{
  programs.i3status= {
    enable = true;
    enableDefault = false;
    modules = {
      "disk /" = {
        position = 2;
        settings = {
          format = " %avail";
        };
      };
      "memory" = {
        settings = {
          format = "  %free";
          format_degraded = "  LOW: %free";
          memory_used_method = "classical";
        };
        position = 2;
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
          format = "%a %d/%m %H:%M";
        };
        position = 9;
      };
    };
  };

}
