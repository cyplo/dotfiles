{ config, pkgs, lib, ... }:
{
  sound.enable = true;
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
  hardware.u2f.enable = true;
  hardware.brightnessctl.enable = true;
  hardware.sane.enable = true;
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    extraConfig = ''
            [General]
            Enable=Source,Sink,Media,Socket
    '';
  };

  powerManagement.cpuFreqGovernor = (lib.mkForce null);
  powerManagement.powertop.enable = true;

}
