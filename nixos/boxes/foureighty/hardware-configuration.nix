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

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/c2deaeaa-cb76-4d29-a603-0cf42f6e829f";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FC06-82E6";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cb12122c-f0ef-4c43-bac1-6b8410a51a54";
    fsType = "btrfs";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.video.hidpi.enable = lib.mkDefault true;

  nix.maxJobs = 2;
  nix.buildCores = 6;
}
