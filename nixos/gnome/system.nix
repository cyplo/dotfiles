{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
    desktopManager.gnome3.enable = true;
  };
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
  users.users.cyryl.packages = with pkgs; [];
}

