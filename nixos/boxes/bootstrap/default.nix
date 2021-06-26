{ config, pkgs, inputs, ... }:
{
  networking.hostName = "fixme";

  imports = [
    ./hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-intel.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  time.timeZone = "Europe/London";

  fonts.fontconfig.enable = true;
}
