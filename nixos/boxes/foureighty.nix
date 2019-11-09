{ config, pkgs, ... }:
{

  networking.hostName = "foureighty";
  boot = {
    kernelPackages = pkgs.linuxPackages_latest_hardened;
    extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
    kernelPatches = [{
      name = "bpf_plus_newer_intel";
      patch = null;
      extraConfig = ''
        MCORE2 y
        ENERGY_MODEL y
        X86_INTEL_MPX y
        INTEL_TXT y

        PREEMPT_VOLUNTARY y

        BPF y
        BPF_EVENTS y
        BPF_JIT y
        BPF_SYSCALL y
        DUMMY m
        HAVE_EBPF_JIT y
        KALLSYMS_ALL y
        NET_ACT_BPF m
        NET_ACT_GACT m
        NET_ACT_POLICE m
        NET_CLS_BPF m
        NET_SCH_SFQ m
        VXLAN m
      '';}
    ];

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
    services.fprintd.enable = true;

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
