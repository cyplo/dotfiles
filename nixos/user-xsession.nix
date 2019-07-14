{ config, pkgs, ... }:
let
  mod = "Mod4";
in
  {
    services = {
      network-manager-applet.enable = true;

      polybar = {
        enable = true;
        package =
          pkgs.polybar.override {
            i3GapsSupport = true;
          };
          config = {
            "bar/top" = {
              font-0 = "mononoki:size-10";
              width = "100%";
              height = "2%";
              radius = 0;
              background = "#fdf6e3"; # solarized base3
              foreground = "#657b83"; # solarized base00
              tray-position = "right";
              tray-detached = false;
              tray-maxsize = 16;
              tray-transparent = false;
              tray-background = "#fdf6e3";
              tray-offset-x = 0;
              tray-offset-y = 0;
              tray-padding = 0;
              tray-scale = "1.0";
              module-margin = 4;
              modules-center = "date";
              modules-right = "battery";
            };
            "module/date" = {
              type = "internal/date";
              internal = 5;
              date = "%Y.%m.%d";
              time = "%H.%M";
              label = "%date%..%time%";
            };
            "module/battery" = {
              type = "internal/battery";
              battery = "BAT0";
              adapter = "AC";
              full-at = 99;
            };
          };
          script = "polybar main_bar &";
        };
      };

      xsession = {
        enable = true;
        windowManager.i3 = {
          enable = true;
          package = pkgs.i3-gaps;
          config = {
            startup = [
              { command = "exec i3-sensible-terminal"; always = true; notification = false; }
            ];

            bars = [];
            gaps = {
              inner = 12;
              outer = 0;
              smartGaps = true;
              smartBorders = "on";
            };

            modifier = mod;
            keybindings = {
              "${mod}+Return" = "exec i3-sensible-terminal";
              "${mod}+Shift+q" = "kill";
              "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show combi -combi-modi window#run#ssh -modi combi";
              "${mod}+f" = "fullscreen toggle";
              "${mod}+l" = "exec loginctl lock-session";
              "${mod}+Shift+e" = "exec i3-msg exit";
            };
          };
        };
      };
    }
