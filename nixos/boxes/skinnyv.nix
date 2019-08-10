{ config, pkgs, ... }:
{
  networking.hostName = "skinnyv";
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "i915.enable_rc6=7"
    ];
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/ef6e91d9-c477-4ab7-ae39-4a0ee413cebe";
        preLVM = true;
        allowDiscards = true;
      }];
      loader.grub = {
        device = "nodev";
        efiSupport = true;
      };
      loader.efi.canTouchEfiVariables = true;
    };
    time.timeZone = "Europe/London";

    imports = [
      /etc/nixos/hardware-configuration.nix
      ../boot.nix
      ../common.nix
      ../gfx-intel.nix
    ];
  }
