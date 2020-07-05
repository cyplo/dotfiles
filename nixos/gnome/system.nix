{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    displayManager.gdm.nvidiaWayland = true;
    desktopManager.gnome3.enable = true;
  };
  services.dbus.packages = with pkgs; [ gnome2.GConf gnome3.dconf ];
  users.users.cyryl.packages = with pkgs.gnomeExtensions; [
    caffeine clipboard-indicator sound-output-device-chooser gsconnect
  ];
}

