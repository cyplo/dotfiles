
{ config, pkgs, ... }:
{

 networking.hostName = "foureighty";
 boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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

  time.timeZone = "Europe/London";

  hardware.bumblebee.enable = true;
  hardware.bumblebee.connectDisplay = true;

  hardware.trackpoint.enable = true;

  services.fprintd.enable = true;

  systemd.services.cpu-throttling = {
    enable = true;
    description = "CPU Throttling Fix";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    path = [ pkgs.msr-tools ];
    script = "wrmsr -a 0x1a2 0x3000000";
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  systemd.timers.cpu-throttling = {
    enable = true;
    description = "CPU Throttling Fix";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    timerConfig = {
      OnActiveSec = 60;
      OnUnitActiveSec = 60;
      Unit = "cpu-throttling.service";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
    enableHardening = false; #needed for 3D acceleration
  };

  imports = [
    /etc/nixos/hardware-configuration.nix
    ../boot.nix
    ../common.nix 
    ../gfx-intel.nix
  ];
}
