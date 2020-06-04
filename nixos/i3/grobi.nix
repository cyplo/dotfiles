{ config, pkgs, ... }:
{

  home.packages = with pkgs; [ grobi ];
  services.grobi = {
    enable = true;
    executeAfter = [
      "${pkgs.systemd}/bin/systemctl --user restart picom"
      "${pkgs.i3}/bin/i3-msg restart"
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
        outputs_connected = [ "eDP1" ];
        configure_single = "eDP1";
        execute_after = [
          "${pkgs.xorg.xrandr}/bin/xrandr --dpi 144"
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
