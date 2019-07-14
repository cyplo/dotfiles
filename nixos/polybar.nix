{ config, pkgs, ... }:
{
  services.polybar = {
    enable = true;
    script = "polybar -r main_bar &";
    config = {
      "bar/main_bar" = {
        font-0 = "DejaVu Sans Mono for Powerline:size=10.0;weight=bold";
        background = "#002b36";
        foreground = "#839496";
        bottom = "false";
        height = 50;
        fixed-center = "true";
        line-size = 6;
        padding-right = "1%";
        module-margin-left = 1;
        module-margin-right = 1;
        modules-left = "xwindow";
        modules-center = "date";
        modules-right = "org-clock volume backlight filesystem memory cpu network";
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%a %d.%m";
        time = "%H:%M";
        label = "%date% %time%";
      };
      "settings" = {screenchange-reload = "true";};
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:30:...%";
        label-padding = 10;
      };
      "module/network" = {
        type = "internal/network";
        interface = "wlp1s0";
        interval = "3.0";
        format-connected = "<label-connected>";
        label-connected = " %essid%";
      };
      "module/cpu" = {
        type = "internal/cpu";
        label = " %percentage:2%%";
      };
      "module/memory" = {
        type = "internal/memory";
        label = " %percentage_used%%";
      };
      "module/filesystem" = {
        type = "internal/fs";
        mount-0 = "/";
        mount-1 = "/home";
        label-mounted = " %percentage_used%%";
      };
      "module/volume" = {
        type = "internal/alsa";
        label-volume = " %percentage%";
        label-muted = "";
        click-left = "pactl set-sink-mute 0 toggle";
      };
      "module/backlight" = {
        type = "internal/backlight";
        format = "<ramp>";
        card = "intel_backlight";
        ramp-0 = "🌕";
        ramp-1 = "🌔";
        ramp-2 = "🌓";
        ramp-3 = "🌒";
        ramp-4 = "🌑";
      };
    };
  };

}
