
{ config, pkgs, ... }:
{

 networking.hostName = "foureighty";
 boot = {
    initrd.kernelModules = [ "i915" ];
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

  imports = [
    /etc/nixos/hardware-configuration.nix
    ../boot.nix
    ../common.nix 
    ../gfx-intel.nix
  ];
}
