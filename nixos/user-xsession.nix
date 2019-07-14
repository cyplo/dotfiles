{ config, pkgs, ... }:
let
  mod = "Mod4";
in
  {
    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config = {
          modifier = mod;
          keybindings = {
            "${mod}+Return" = "exec i3-sensible-terminal";
            "${mod}+Shift+q" = "kill";
            "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show combi -combi-modi window#run#ssh -modi combi";
            "${mod}+f" = "fullscreen toggle";
          };
        };
      };
    };
  }
