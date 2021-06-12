{ config, pkgs, ... }:
{
  networking.hostName = "skinnyv";

  imports = [
    ./hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-intel.nix
    ../../i3
    ../../distributed-builds.nix
    ../../gui
    ../../git
    ../../backups.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "Europe/London";

  fonts.fontconfig.enable = true;
}
