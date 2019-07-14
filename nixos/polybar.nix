{ config, pkgs, ... }:
{
  services.polybar = {
    enable = true;
    script = "polybar main_bar &";
    config = {
      "bar/main_bar" = {
        bottom = "false";
        height = 50;
        fixed-center = "true";
        line-size = 6;
        padding-right = "1%";
        module-margin-left = 1;
        module-margin-right = 1;
        wm-restack = "bspwm";
        modules-left = "bspwm xwindow";
        modules-center = "date";
        modules-right = "org-clock volume backlight filesystem memory cpu battery network";
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        format = "<label-state> <label-mode>";
        label-monocle = "M";
        label-floating = "S";
        fuzzy-match = "true";
        ws-icon-0 = "1;";
        ws-icon-1 = "2;";
        ws-icon-2 = "3;";
        ws-icon-3 = "4;";
        ws-icon-4 = "5;♞";
        ws-icon-default = "";
        label-mode-padding = "2";
        label-focused = "%icon%";
        label-focused-padding = 2;
        label-empty = '''';
        label-occupied = "%icon%";
        label-occupied-padding = 2;
        label-urgent = "%icon%";
        label-urgent-padding = 2;
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%m-%d %a";
        time = "%H:%M";
        label = "%date% %time%";
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT1";
        adapter = "ADP1";
        full-at = 96;
        format-charging = " <label-charging>";
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-full = " ";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
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
