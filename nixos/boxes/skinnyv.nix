{ config, pkgs, ... }:
{
  networking.hostName = "skinnyv";
  boot = {
    kernelParams = [
      "i915.enable_rc6=7"
    ];
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/8c76bf01-59b3-4c60-b853-e9cb77f3ca14";
        preLVM = true;
        allowDiscards = true;
      }];
  };
  time.timeZone = "Europe/London";
  imports = [ ../common.nix ];
}