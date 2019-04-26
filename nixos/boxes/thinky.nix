
{ config, pkgs, ... }:
{
  networking.hostName = "thinky";
  boot = {
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/------------------------------------";
        preLVM = true;
        allowDiscards = true;
      }];
  };
  time.timeZone = "Europe/Warsaw";
  imports = [ ../common.nix ];
}