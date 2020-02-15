{ config, pkgs, ... }:
{
  imports = [
    ./polybar/polybar.nix
    ./i3.nix
    ./dunst.nix
    ./autorandr.nix
    ./rofi.nix
  ];

  services = {
    compton = {
      enable = true;
      vSync = "opengl-oml";
    };
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    network-manager-applet.enable = true;
    pasystray.enable = true;
  };

  xsession = {
    enable = true;
  };


}
