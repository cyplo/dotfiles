{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 95;
    };

    kernelModules = [ "kvm-intel" ];

    initrd = {
      kernelModules = [ "dm-snapshot" ];
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    };

    loader.grub = {
      device = "nodev";
      efiSupport = true;
    };

    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems."/" =
    { device = "/dev/mapper/crypt";
    fsType = "btrfs";
  };

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/c2b23e5e-82c6-45dc-b07d-a8f9be03440e";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C380-BA8A";
    fsType = "vfat";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.video.hidpi.enable = lib.mkDefault true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 75;
  };

  nix.maxJobs = 2;
  nix.buildCores = 6;
}
