{ config, pkgs, ... }:
{
  programs.dconf.enable = true;
  xdg.portal.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-kde ];

  services = {
    physlock = {
      enable = true;
      allowAnyUser = true;
    };

    fractalart.enable = true;
    colord.enable = true;
    xserver.windowManager.i3.enable = true;
    xserver.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };
}
