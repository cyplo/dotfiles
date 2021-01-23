{ config, pkgs, ... }:
let
  mod = "Mod4";
in
  {
    wayland.windowManager.sway.config.keybindings = {
      "${mod}+Shift+e" = "exit";
      "${mod}+Shift+r" = "reload";
      "${mod}+Shift+l" = "exec swaylock -c 657b83";
      "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";

      "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@  -5%";
      "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@  toggle";
      "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@  toggle";

      "XF86MonBrightnessUp" = "exec light -s sysfs/backlight/intel_backlight -A 5";
      "XF86MonBrightnessDown" = "exec light -s sysfs/backlight/intel_backlight -U 5";

      "Print" = "exec ${pkgs.gnome3.gnome-screenshot}/bin/gnome-screenshot -i";

      "${mod}+r" = "exec ${pkgs.wofi}/bin/wofi --show drun,run";
      "${mod}+c" = "exec ${pkgs.clipman}/bin/clipman pick -t wofi";
      "${mod}+q" = "kill";
      "${mod}+f" = "fullscreen toggle";

      "${mod}+h"   = "focus left";
      "${mod}+j"   = "focus down";
      "${mod}+k"   = "focus up";
      "${mod}+l"   = "focus right";

      "${mod}+1" = "workspace 1";
      "${mod}+2" = "workspace 2";
      "${mod}+3" = "workspace 3";
      "${mod}+4" = "workspace 4";
      "${mod}+5" = "workspace 5";
      "${mod}+6" = "workspace 6";
      "${mod}+7" = "workspace 7";
      "${mod}+8" = "workspace 8";
      "${mod}+9" = "workspace 9";
      "${mod}+0" = "workspace 10";

      "${mod}+Shift+1" = "move container to workspace 1";
      "${mod}+Shift+2" = "move container to workspace 2";
      "${mod}+Shift+3" = "move container to workspace 3";
      "${mod}+Shift+4" = "move container to workspace 4";
      "${mod}+Shift+5" = "move container to workspace 5";
      "${mod}+Shift+6" = "move container to workspace 6";
      "${mod}+Shift+7" = "move container to workspace 7";
      "${mod}+Shift+8" = "move container to workspace 8";
      "${mod}+Shift+9" = "move container to workspace 9";
      "${mod}+Shift+0" = "move container to workspace 10";

      "${mod}+Ctrl+Left" = "move workspace to output left";
      "${mod}+Ctrl+Right" = "move workspace to output right";
      "${mod}+Ctrl+Up" = "move workspace to output up";
      "${mod}+Ctrl+Down" = "move workspace to output down";
    };
  }
