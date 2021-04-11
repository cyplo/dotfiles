{ config, pkgs, ... }:
{
  networking.hostName = "fixme";

  imports = [
    ./hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../distributed-builds.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/London";
}
