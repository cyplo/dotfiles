{ config, pkgs, ... }:
{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.packages = with pkgs; [ kdeconnect ] ;
}
