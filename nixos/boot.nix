{ config, pkgs, ... }:
{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernel.sysctl = {
      "vm.swappiness" = 1;
    };
    loader.grub = {
      enable = true;
      version = 2;
      useOSProber = true;
    };
  };
}
