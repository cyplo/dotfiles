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
    xserver.windowManager.i3.enable = true;
    xserver.windowManager.i3.package = pkgs.i3-gaps;
    xserver.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };
}
