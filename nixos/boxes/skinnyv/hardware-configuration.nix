{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9dba116f-c9fe-403a-a8e2-f9fdab23f1f1";
    fsType = "btrfs";
    options = [ "compress=zstd" ];
  };

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/0c192a18-178f-4598-a1ed-5295ef2abdc4";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0A6A-AAFC";
    fsType = "vfat";
  };

  swapDevices = [ ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
