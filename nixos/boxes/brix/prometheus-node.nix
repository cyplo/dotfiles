{ config, pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 9100 ];
  services.prometheus = {
    enable = true;
    exporters.node.enable = true;
  };
}
