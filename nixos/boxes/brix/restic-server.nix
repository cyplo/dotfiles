{ config, pkgs, ... }:
{

  networking.firewall.allowedTCPPorts = [ 8000 ];
  services.restic.server = {
    enable = true;
    dataDir = "/data/restic";
    appendOnly = true;
    prometheus = true;
    extraFlags = [ "--no-auth" ];
  };

}
