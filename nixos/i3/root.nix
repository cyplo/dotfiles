{ config, pkgs, ... }:
{
  services = {
    colord.enable = true;
    autorandr.enable = true;
    xserver.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };
}
