{ config, pkgs, ... }:
{
  programs.dconf.enable = true;
  services = {
    physlock = {
      enable = true;
      allowAnyUser = true;
    };

    colord.enable = true;
    autorandr.enable = true;
    xserver.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };
}
