
{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
    desktopManager.default = "plasma5";
    desktopManager.plasma5.enable = true;
  };
  users.users.cyryl.packages = with pkgs; [];
}

