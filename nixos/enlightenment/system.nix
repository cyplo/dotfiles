{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.enlightenment.enable = true;
  };
  users.users.cyryl.packages = with pkgs; [];
}

