{ config, pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./i3-status.nix
    ./dunst.nix
    ./rofi.nix
    ./kdeconnect.nix
  ];

  home.sessionVariables = {
    CM_LAUNCHER="rofi";
  };

  services = {
    picom = {
      enable = true;
      vSync = true;
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
