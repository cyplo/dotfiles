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
        "restart-compton" = "systemctl --user restart compton";
        "restart-i3" = "i3-msg restart";
        "restart-services" = "systemctl --user restart kdeconnect-indicator.service kdeconnect.service network-manager-applet.service pasystray.service polybar.service";
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
      "foureighty-docked" = {
        fingerprint = {
          eDP1 = "00ffffffffffff0006af362300000000001b0104a51f117802f4f5a4544d9c270f505400000001010101010101010101010101010101e65f00a0a0a040503020350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343051414e30322e33200a00b2";
          DP1 ="00ffffffffffff0026cd4d66f3030000271d0103803c22782ef6d5a7544b9e250d5054bfef80714f8140818081c09500b300d1c001014dd000a0f0703e8030203500544f2100001a000000ff0031313636333933393031303131000000fd00184c1fa03c000a202020202020000000fc00504c3237393255480a2020202001bd020340f35410050403020716011f12131420151106615d5e5f23090707830100006d030c001000387820006001020367d85dc40178c000e3050301e40f000001023a801871382d40582c4500544f2100001e565e00a0a0a0295030203500544f2100001af45100a0f070198030203500544f2100001e000000000000000000d6";
        };
        config = {
          DP1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            dpi = 192;
          };
          eDP1 = {
            enable = false;
            primary = false;
            position = "3840x0";
            mode = "2560x1440";
          };
        };
      };
    };
  };

  imports = [
    ./polybar/polybar.nix
    ./i3.nix
  ];
}
