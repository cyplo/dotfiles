{ config, pkgs, lib, ... }:
{
  hardware.enableRedistributableFirmware = true;
  services.smartd.enable = true;
  services.fstrim.enable = true;
  environment.systemPackages = with pkgs; [
    smartmontools
  ];
  services.fwupd.enable = true;
  services.thermald.enable = true;
}
