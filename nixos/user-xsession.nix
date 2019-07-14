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
            inner = 12;
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

    imports = [
      ./polybar.nix
    ];
  }
