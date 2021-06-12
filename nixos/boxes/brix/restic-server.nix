{ config, pkgs, ... }:
{

  networking.firewall.allowedTCPPorts = [ 8000 ];
  services.restic.server = {
    enable = true;
    dataDir = "/data/restic";
    appendOnly = true;
    prometheus = true;
    listenAddress = "brix.cyplo.github.beta.tailscale.net:8000";
    extraFlags = [ "--no-auth" ];
  };

}
