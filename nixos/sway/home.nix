{ config, pkgs, ... }:
{

  programs.mako.enable = true;

  imports = [
  ];

  home.sessionVariables = {
  };

  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.wrapperFeatures.base = true;
  wayland.windowManager.sway.wrapperFeatures.gtk = true;


  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    network-manager-applet.enable = true;
    pasystray.enable = true;
  };

  services.udiskie.enable = true;

}
