{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPortRanges = [ { from = 1716; to = 1764; }  ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1716; to = 1764; }  ];
}
