{ config, pkgs, ... }:
{

  boot = {
    kernelPackages = pkgs.linuxPackages_latest_hardened;
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "btrfs" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
  };

  services.btrfs.autoScrub.enable = true;
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/78e8e5b5-9068-4381-8e85-b4297607f9ea";
    fsType = "btrfs";
    options = [ "autodefrag" "space_cache" "inode_cache" "noatime" "nodiratime" "compress=zstd" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/68bb21bd-90da-4da4-b97e-c6da3b1f8235";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0129-8152";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5f635052-a940-466e-a7cf-4799adace60e"; }
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
