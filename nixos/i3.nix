{ config, pkgs, ... }:
let
  mod = "Mod4";
in
  {

    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        startup = [
          { command = "exec setxkbmap -layout pl"; always = true; notification = false; }
          { command = "exec autorandr -c"; always = true; notification = false; }
          { command = "exec i3-sensible-terminal"; always = false; notification = false; }
          { command = "exec $HOME/dev/dotfiles/lock.sh"; always = false; notification = false; }
        ];
        window = {
          hideEdgeBorders = "horizontal";
          titlebar = false;
          border = 0;
        };

        workspaceLayout = "tabbed";
        bars = [];
        gaps = {
          inner = 8;
          outer = 0;
          smartGaps = true;
          smartBorders = "on";
        };

        modifier = mod;
        keybindings = {
          "${mod}+Shift+e" = "exec i3-msg exit";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+l" = "exec physlock -d";
          "${mod}+Return" = "exec i3-sensible-terminal";

          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@  -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@  toggle";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@  toggle";

          "XF86MonBrightnessUp" = "exec light -s sysfs/backlight/intel_backlight -A 5";
          "XF86MonBrightnessDown" = "exec light -s sysfs/backlight/intel_backlight -U 5";

          "${mod}+r" = "exec ${pkgs.rofi}/bin/rofi -show combi -combi-modi window#run#ssh -modi combi";
          "${mod}+c" = "exec ${pkgs.clipmenu}/bin/clipmenu";
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
        };
      };
    };

  }
