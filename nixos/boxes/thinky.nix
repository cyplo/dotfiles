
{ config, pkgs, ... }:
{
  networking.hostName = "thinky";
  boot = {
    kernelPackages = pkgs.linuxPackages_latest_hardened;
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/962caed1-9dd5-4771-9a8f-3d3f5854af2e";
        preLVM = true;
        allowDiscards = true;
      }];
      loader.grub = {
        device = "/dev/sda";
      };
    };
    time.timeZone = "Europe/Warsaw";
    imports = [
      /etc/nixos/hardware-configuration.nix
      ../boot.nix
      ../common.nix
      ../gfx-intel.nix
    ];
  }
