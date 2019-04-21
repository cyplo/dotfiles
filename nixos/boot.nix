{ config, pkgs, ... }:
{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/8c76bf01-59b3-4c60-b853-e9cb77f3ca14";
        preLVM = true;
        allowDiscards = true;
      }
    ];
    loader.grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
  };
}