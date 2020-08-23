{ config, pkgs, ... }:
{
  services.kdeconnect = {
    enable = true;
    indicator = false;
  };

  home.packages = with pkgs; [ kdeconnect ] ;
}
