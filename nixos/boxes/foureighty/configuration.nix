{ config, pkgs, ... }:
{
  networking.hostName = "foureighty";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest_hardened;

    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/a9e8a44f-15be-4844-a0a1-46892cc5e44e";
        allowDiscards = true;
      };
    };

    loader.grub = {
      device = "nodev";
      efiSupport = true;
    };

    loader.efi.canTouchEfiVariables = true;
  };

  time.hardwareClockInLocalTime = true;
  time.timeZone = "Europe/London";

  hardware.trackpoint.enable = true;
  services.hardware.bolt.enable = true;
  services.fprintd = {
    enable = true;
  };

  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-nvidia-optimus.nix
    ../../zerotier.nix
    ../../distributed-builds.nix
    ../../libvirt.nix
    ../../gnome/system.nix
    ../../backups.nix
  ];


  nix.maxJobs = 2;
  nix.buildCores = 6;
}
