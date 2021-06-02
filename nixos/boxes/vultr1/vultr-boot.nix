{ config, pkgs, ... }:
{

  boot = {
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
    initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

    initrd.postDeviceCommands = ''
      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
        hwclock -s
    '';

    kernelPackages = pkgs.linuxPackages_latest_hardened;
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "/dev/vda";
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/d37c4c81-4807-4b8b-bcd4-05ae76bccbaa";
      fsType = "ext4";
    };

    swapDevices = [
      {
        device = "/swapfile";
        size = 2048;
      }
    ];

  }

