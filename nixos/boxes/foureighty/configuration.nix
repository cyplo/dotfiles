{ config, pkgs, ... }:
{
  networking.hostName = "foureighty";

  boot = {
    # need unlocked kernel for throttled daemon
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

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
  services.throttled.enable = true;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
  services.hardware.bolt.enable = true;
  services.fprintd = {
    enable = true;
  };

  imports = [
    ./hardware-configuration.nix
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
