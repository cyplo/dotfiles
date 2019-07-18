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
      "mds=full"
    ];

    kernelPatches = [ {
      name = "native";
      patch = null;
      extraConfig = ''
        SLAB_FREELIST_RANDOM y
        SLAB_FREELIST_HARDENED y
        REFCOUNT_FULL y
        MODVERSIONS y
        GENERIC_CPU n
        MCORE2 y
        X86_INTEL_USERCOPY y
        X86_USE_PPRO_CHECKSUM y
        X86_P6_NOP y
        X86_INTEL_MPX y
        KEXEC n
        IA32_EMULATION y
        X86_X32 y
      '';
    } ];

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

    hardware.bumblebee.enable = true;

    imports = [
      /etc/nixos/hardware-configuration.nix
      ../quirks/thinkpad-cpu-throttling.nix
      ../boot.nix
      ../common.nix
      ../gfx-intel.nix
      ../virtualbox.nix
    ];
  }
