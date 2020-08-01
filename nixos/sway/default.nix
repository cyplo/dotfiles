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
        ./keybindings.nix
      ];

      home.sessionVariables = {
      };

      home.packages = with pkgs; [
        wl-clipboard
        clipman
        wofi
      ];

      home.file.".config/wofi/style.css".source = ../../.config/wofi/style.css;
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.base = true;
        wrapperFeatures.gtk = true;

        config = {
          modifier = "${mod}";
          menu = "${pkgs.wofi}/bin/wofi --show drun,run";
          terminal = "${pkgs.alacritty}/bin/alacritty";
          bars = [
            {
              position = "top";
              colors.background= "#002b36";
              fonts = [ "Fira Code Nerd Font 10" ];
              statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3/status.toml";
              trayOutput = "primary";
            }
          ];
          startup = [
            { command = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store"; }
            { command = "${pkgs.clipman}/bin/clipman restore"; }
            { command = ''swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -f -c 000000'
            ''; }
          ];
          output.eDP-1.scale = "1.7";
          input."1:1:AT_Translated_Set_2_keyboard" = {
            xkb_layout = "pl";
            xkb_options = "caps:ctrl_modifier";
          };
          input."2:7:SynPS/2_Synaptics_TouchPad" = {
            tap = "enabled";
          };
        };
      };
    };
  }

