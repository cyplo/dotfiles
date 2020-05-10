{ config, pkgs, ... }:
{
  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  xsession = {
    enable = false;
  };

}
