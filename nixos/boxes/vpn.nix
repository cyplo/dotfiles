{ config, pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "d3ecf5726d580b5a" ];
  };

  networking.hosts = {
    "172.23.153.159" = [ "brix.vpn" ];
    "172.23.28.139" = [ "vultr1.vpn" ];
  };
}
