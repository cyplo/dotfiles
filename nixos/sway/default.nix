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
        XDG_CURRENT_DESKTOP="Unity";
        SDL_VIDEODRIVER="wayland";
        QT_QPA_PLATFORM="wayland-egl";
        QT_WAYLAND_FORCE_DPI="physical";
        QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
      };

      home.packages = with pkgs; [
        firefox-wayland
        wl-clipboard
        clipman
        wofi
        libappindicator-gtk3
      ];

      services.udiskie.enable = true;
      xsession.preferStatusNotifierItems = true;

      home.file.".config/wofi/style.css".source = ../../.config/wofi/style.css;
      home.file.".config/waybar/config".source = ../../.config/waybar/config;
      home.file.".config/waybar/style.css".source = ../../.config/waybar/style.css;
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.base = true;
        wrapperFeatures.gtk = true;

        extraConfig = ''
        '';
        extraSessionCommands = ''
        '';
        config = {
          modifier = "${mod}";
          menu = "${pkgs.wofi}/bin/wofi --show drun,run";
          terminal = "${pkgs.alacritty}/bin/alacritty";
          workspaceLayout = "tabbed";
          window = {
            hideEdgeBorders = "both";
            titlebar = false;
          };
          bars = [
            {
              position = "top";
              command = "${pkgs.waybar}/bin/waybar";
            }
          ];
          startup = [
            { command = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store"; }
            { command = "${pkgs.clipman}/bin/clipman restore"; }
            { command = ''swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'swaymsg "output * dpms off" && systemctl suspend' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -f -c 657b83'
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

