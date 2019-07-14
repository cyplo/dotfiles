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
            { command = "exec i3-sensible-terminal"; always = true; notification = false; }
          ];

          bars = [];
          gaps = {
            inner = 8;
            outer = 0;
            smartGaps = true;
            smartBorders = "on";
          };

          modifier = mod;
          keybindings = {
            "${mod}+Return" = "exec i3-sensible-terminal";
            "${mod}+Shift+q" = "kill";
            "${mod}+r" = "exec ${pkgs.rofi}/bin/rofi -show combi -combi-modi window#run#ssh -modi combi";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+l" = "exec loginctl lock-session";
            "${mod}+Shift+e" = "exec i3-msg exit";
            "${mod}+Shift+r" = "restart";
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
              position = "0x0";
              mode = "2560x1440";
              rate = "60.00";
              scale = { x=1.25; y=1.25; };
            };
          };
        };
      };
    };

    imports = [
      ./polybar.nix
    ];
  }
