{ config, pkgs, ... }:
{
  services = {
    compton = {
      enable = true;
      vSync = "opengl-oml";
    };
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    network-manager-applet.enable = true;
    pasystray.enable = true;
  };

  xsession = {
    enable = true;
  };

  programs.autorandr = {
    enable = true;

    hooks = {
      postswitch = {
        "restart-polybar" = "systemctl --user restart polybar";
        "restart-kde-connect-indicator" = "systemctl --user restart kdeconnect-indicator";
      };
    };

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
    ./i3/polybar/polybar.nix
    ./i3/i3.nix
  ];
}
