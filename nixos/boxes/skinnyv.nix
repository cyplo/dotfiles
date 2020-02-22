{ config, pkgs, ... }:
{
  networking.hostName = "skinnyv";

  nixpkgs.config.packageOverrides = pkgs: {
    linux_latest_hardened = pkgs.linux_latest_hardened.override {
      extraConfig = ''
        IA32_EMULATION y
        KVM m
        KVM_INTEL m
      '';
      features.ia32Emulation = true;
      enableParallelBuilding = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest_hardened;
    kernelParams = [
      "i915.enable_rc6=7"
    ];
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/ef6e91d9-c477-4ab7-ae39-4a0ee413cebe";
        preLVM = true;
        allowDiscards = true;
      }];
      loader.grub = {
        device = "nodev";
        efiSupport = true;
      };
      loader.efi.canTouchEfiVariables = true;
    };
    time.timeZone = "Europe/London";

    imports = [
      /etc/nixos/hardware-configuration.nix
      ../boot.nix
      ../common.nix
      ../gfx-intel.nix
      ../zerotier.nix
      ../i3/system.nix
      ../distributed-builds.nix
    ];
  }
