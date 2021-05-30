{ config, lib, pkgs, ... }:

{
  imports = [ ];

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 75;
    };

    kernelModules = [ "kvm-intel" "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

    initrd = {
      kernelModules = [ "dm-snapshot" ];
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/a9e8a44f-15be-4844-a0a1-46892cc5e44e";
          allowDiscards = true;
        };
      };
    };

    loader.grub = {
      device = "nodev";
      efiSupport = true;
    };

    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems."/" = { device = "/dev/disk/by-uuid/7ae9348d-604e-4196-a27b-24a7495438c3"; fsType = "ext4"; };

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/C4DD-2374"; fsType = "vfat"; };

  swapDevices = [ ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  nix.maxJobs = 2;
  nix.buildCores = 6;
}
