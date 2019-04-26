{ config, pkgs, ... }:
{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
  };
}