{ config, pkgs, lib, ... }:
{
  boot.kernelModules = [ "fuse" ];
  services.smartd.enable = true;

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
  hardware.sane.enable = true;
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    extraConfig = ''
            [General]
            Enable=Source,Sink,Media,Socket
    '';
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr pkgs.samsung-unified-linux-driver pkgs.splix ];
  };

  hardware.printers.ensurePrinters = [{
    description = "Epson XP540";
    name = "epsonxp540";
    deviceUri = "ipp://epsonxp540.lan/ipp/print";
    model = "epson-inkjet-printer-escpr/Epson-XP-540_Series-epson-escpr-en.ppd";
    ppdOptions = { PageSize = "A4"; Duplex = "DuplexNoTumble"; };
  }];

  powerManagement.enable = (lib.mkForce true);
  powerManagement.cpuFreqGovernor = (lib.mkForce null);
  powerManagement.powertop.enable = true;
}
