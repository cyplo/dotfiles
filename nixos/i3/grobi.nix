{ config, pkgs, ... }:
{

  home.packages = with pkgs; [ grobi ];
  services.grobi = {
    enable = true;
    executeAfter = [
      "${pkgs.systemd}/bin/systemctl --user restart picom"
      "${pkgs.systemd}/bin/systemctl --user restart kdeconnect-indicator kdeconnect network-manager-applet pasystray udiskie"
    ];
    rules = [
      {
        name = "foureighty-docked";
        outputs_connected = [ "eDP1" "DP1" ];
        configure_single = "DP1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 192"
          "${pkgs.xorg.xrandr}/bin/xrandr --output DP1 --primary"
        ];
      }
      {
        name = "foureighty";
        outputs_connected = [ "eDP1-AUO-9014-0--" ];
        configure_single = "eDP1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 144"
          "${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --primary"
        ];
      }
      {
        name = "skinnyv";
        outputs_connected = [ "eDP1-AUO-8493-0--" ];
        configure_single = "eDP1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 120"
          "${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --primary"
        ];
      }
      {
        name = "form3-docked";
        outputs_connected = [ "eDP-1-1" "DP-1-1" ];
        configure_single = "DP-1-1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 192"
        ];
      }
      {
        name = "form3";
        outputs_connected = [ "eDP-1-1" ];
        configure_single = "eDP-1-1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 256"
        ];
      }
    ];
  };
}
