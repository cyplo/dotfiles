{ config, pkgs, ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "d3ecf5726d580b5a" ];
  };

  networking.hosts = {
    "172.23.223.219" = [ "brix.local" ];
  };

}
