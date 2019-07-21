{ config, pkgs, ... }:
let
  mod = "Mod4";
in
  {
    services = {
      network-manager-applet.enable = true;
    };

    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        config = {
          startup = [
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

            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";

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
          };
        };
      };
    };

    programs.autorandr = {
      enable = true;

      profiles = {
        "foureighty-alone" = {
          fingerprint = {
            eDP1 = "00ffffffffffff0006af362300000000001b0104a51f117802f4f5a4544d9c270f505400000001010101010101010101010101010101e65f00a0a0a040503020350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343051414e30322e33200a00b2";
          };
          config = {
            eDP1 = {
              enable = true;
              primary = true;
              mode = "2560x1440";
              dpi = 144;
            };
          };
        };
      };
    };

    imports = [
      ./polybar.nix
    ];
  }
