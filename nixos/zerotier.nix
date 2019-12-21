{ config, pkgs, ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "d3ecf5726d580b5a" ];
  };
}
