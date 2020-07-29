{ config, pkgs, ... }:
let
  mod = "Mod4";
in
  {
    services.dbus.packages = with pkgs; [ gnome2.GConf gnome3.dconf ];
    services.dbus.socketActivated = true;
    programs.sway.enable = true;
    systemd.defaultUnit = "graphical.target";
    home-manager.users.cyryl = {...}: {
      programs.mako.enable = true;

      imports = [
      ];

      home.sessionVariables = {
      };


      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.base = true;
        wrapperFeatures.gtk = true;

        config = {
          modifier = "${mod}";
          keybindings = {
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";

            "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          };
        };
      };
    };
  }

