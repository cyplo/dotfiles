{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPortRanges = [ { from = 1716; to = 1764; }  ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1716; to = 1764; }  ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.gsconnect
    (
      vim_configurable.override {
        python = python3;
      }
    )
  ];
}