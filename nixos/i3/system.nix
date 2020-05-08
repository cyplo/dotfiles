{ config, pkgs, ... }:
{
  programs.dconf.enable = true;
  services = {
    physlock = {
      enable = true;
      allowAnyUser = true;
    };

    colord.enable = true;
    xserver.windowManager.i3.enable = true;
    xserver.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };
}
