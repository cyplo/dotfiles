{ config, lib, pkgs, inputs, ... }:
{
  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd = {
      kernelModules = [ "dm-snapshot" ];
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    };

    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
  };

  boot.initrd.luks.devices."crypt".device = "replaceme";

  fileSystems."/" = {
    device = "replaceme";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "replaceme";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nix.maxJobs = 2;
  nix.buildCores = 6;
}
