{ config, pkgs, ... }:
{
  services.polybar = {
    enable = true;
    script = "polybar -r main_bar &";
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      iwSupport = true;
      nlSupport = false;
      githubSupport = true;
    };
    config = {
      "settings" = {screenchange-reload = "true";};
      "bar/main_bar" = {
        font-0 = "DejaVu Sans Mono for Powerline:size=12.0;weight=bold";
        background = "#002b36";
        foreground = "#839496";
        bottom = "false";
        height = 32;
        fixed-center = "true";
        line-size = 6;
        padding-right = "1%";
        module-margin-left = 1;
        module-margin-right = 1;
        modules-left = "i3";
        modules-center = "date";
        modules-right = "memory swap cpu temperature battery1 battery0";
        tray-position = "right";
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%a %d.%m";
        time = "%H:%M";
        label = "%date% %time%";
      };

      "module/i3" = {
        type = "internal/i3";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 5;
        format = "CPU: <label>";
      };

      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = 3;
        interval = 5;
        format = "TEMP: <label>";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 5;
        label = "MEM: %percentage_used%%";
      };

      "module/swap" = {
        type = "internal/memory";
        interval = 15;
        label = "SWAP: %percentage_swap_used%%";
      };

      "module/battery0" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
        poll-interval = "5";
        format-discharging = "<label-discharging>";
        label-discharging = "%time%";
      };

      "module/battery1" = {
        type = "internal/battery";
        battery = "BAT1";
        adapter = "AC";
        poll-interval = "5";
        format-discharging = "<label-discharging>";
        label-discharging = "%time%";
      };

    };
  };

}
