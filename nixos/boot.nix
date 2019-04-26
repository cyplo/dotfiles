{ config, pkgs, ... }:
{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
    };
  };
}