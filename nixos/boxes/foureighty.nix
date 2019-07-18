{ config, pkgs, ... }:
{

  networking.hostName = "foureighty";
  boot = {
    kernelPackages = pkgs.linuxPackages_latest_hardened;
    extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
    initrd.kernelModules = [ "i915" ];
    initrd.availableKernelModules = [
      "aes_x86_64"
      "crypto_simd"
      "aesni_intel"
      "cryptd"
    ];
    kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
      "i915.enable_rc6=7"
      "mds=full"
    ];
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/a9e8a44f-15be-4844-a0a1-46892cc5e44e";
        preLVM = true;
        allowDiscards = true;
      }];
      loader.grub = {
        device = "nodev";
        efiSupport = true;
      };
      loader.efi.canTouchEfiVariables = true;
    };

    time.hardwareClockInLocalTime = true;
    time.timeZone = "Europe/London";

    hardware.trackpoint.enable = true;
    services.fprintd.enable = true;

    imports = [
      /etc/nixos/hardware-configuration.nix
      ../quirks/thinkpad-cpu-throttling.nix
      ../boot.nix
      ../common.nix
      ../gfx-intel.nix
      ../virtualbox.nix
    ];
  }
