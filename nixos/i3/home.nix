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
    picom = {
      enable = true;
      vSync = true;
    };
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    network-manager-applet.enable = true;
    pasystray.enable = true;
  };

  services.udiskie.enable = true;
  services.redshift.enable = true;
  services.redshift.provider = "geoclue2";

  xsession = {
    enable = true;
  };


}
