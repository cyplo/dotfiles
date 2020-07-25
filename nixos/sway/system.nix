{ config, pkgs, ... }:
{
  services.dbus.packages = with pkgs; [ gnome2.GConf gnome3.dconf ];
  services.dbus.socketActivated = true;
  programs.sway.enable = true;
  systemd.defaultUnit = "graphical.target";
}

