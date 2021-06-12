{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.tailscale ];
  services.tailscale = {
    enable = true;
    package = pkgs.tailscale;
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
