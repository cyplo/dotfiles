{ config, pkgs, ... }:
{
  networking.hostName = "fixme";

  imports = [
    ./hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-intel.nix
    ../../zerotier.nix
    ../../i3
    ../../distributed-builds.nix
    ../../gui
    ../../git
    ../../backups.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;
  time.timeZone = "Europe/London";

  fonts.fontconfig.enable = true;
}
