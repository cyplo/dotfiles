{ config, pkgs, ... }:
{
    programs.alacritty = {
      enable = true;
      settings = {
        window.decorations = "none";
        window.startup_mode = "Fullscreen";

        scrolling = {
          history = 32000;
          multiplier = 3;
          faux_multiplier = 3;
          auto_scroll = false;
        };

        tabspaces = 4;

        font = {
          family = "DejaVu Sans Mono for Powerline";
          size = 12.0;
        };

        draw_bold_text_with_bright_colors = true;

        colors = { 
          primary = {
            background= "0x002b36";
            foreground= "0x839496";
            
          };

          normal = {
            black=   "0x073642";
            red=     "0xdc322f";
            green=   "0x859900";
            yellow=  "0xb58900";
            blue=    "0x268bd2";
            magenta= "0xd33682";
            cyan=    "0x2aa198";
            white=   "0xeee8d5";
          };

          bright = {
            black=   "0x002b36";
            red=     "0xcb4b16";
            green=   "0x586e75";
            yellow=  "0x657b83";
            blue=    "0x839496";
            magenta= "0x6c71c4";
            cyan=    "0x93a1a1";
            white=   "0xfdf6e3";
          };

        background_opacity= 1.0;
        dynamic_title= true;
      };
        cursor= {
          style = "Block";
          unfocused_hollow= true;
        };
        live_config_reload= true;
      };
    };
  }
