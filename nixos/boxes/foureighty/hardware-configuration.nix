{ config, lib, pkgs, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 75;
  };

  fileSystems."/" = { device = "/dev/disk/by-uuid/7ae9348d-604e-4196-a27b-24a7495438c3"; fsType = "ext4"; };

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/C4DD-2374"; fsType = "vfat"; };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
}
