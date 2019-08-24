{ config, pkgs, ... }:
{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernel.sysctl = {
      "vm.swappiness" = 1;
      "max_user_watches" = 524288;
    };
    loader.grub = {
      enable = true;
      version = 2;
      useOSProber = true;
    };
  };
}
