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
    services.fprintd = {
      enable = true;
      package = pkgs.fprintd-thinkpad;
    };

    hardware.nvidiaOptimus.disable = true;
    hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
    hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 ];

    services.throttled.enable = true;

    imports = [
      /etc/nixos/hardware-configuration.nix
      ../boot.nix
      ../common.nix
      ../gfx-intel.nix
      ../virtualbox.nix
    ];
  }
