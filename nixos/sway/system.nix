{ config, pkgs, ... }:
{
  services.dbus.packages = with pkgs; [ gnome2.GConf gnome3.dconf ];
  programs.sway.enable = true;
  systemd.defaultUnit = "graphical.target";
}

