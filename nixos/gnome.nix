{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
    desktopManager.gnome3.enable = true;
  };
  users.users.cyryl.packages = with pkgs; [];
}

