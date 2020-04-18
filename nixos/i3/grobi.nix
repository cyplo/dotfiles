{ config, pkgs, ... }:
{

  home.packages = with pkgs; [ grobi ];
  services.grobi = {
    enable = true;
    executeAfter = [
      "systemctl --user restart picom"
      "i3-msg restart"
      "systemctl --user restart kdeconnect-indicator.service kdeconnect.service network-manager-applet.service pasystray.service"
    ];
    rules = [
      {
        name = "foureighty-docked";
        outputs_connected = [ "eDP1" "DP1" ];
        configure_single = "DP1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 192"
        ];
      }
      {
        name = "foureighty";
        outputs_connected = [ "eDP1" ];
        configure_single = "eDP1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 144"
        ];
      }
    ];
  };
}
