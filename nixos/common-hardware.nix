{ config, pkgs, lib, ... }:
{
  boot.kernelModules = [ "fuse" ];
  services.smartd.enable = true;

  sound.enable = true;

  networking.networkmanager.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    daemon.config = {
      nice-level= -15;
      realtime-scheduling = "yes";
    };
  };

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    config = {
      General = { Enable = "Source,Sink,Media,Socket"; };
    };
  };

  services.blueman.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ epson-escpr samsung-unified-linux-driver splix ];
  };

  hardware.printers.ensurePrinters = [{
    description = "Epson XP-540 via brix";
    name = "epson_xp540_via_brix";
    deviceUri = "ipp://brix.vpn:631/printers/epson_xp540";
    model = "epson-inkjet-printer-escpr/Epson-XP-540_Series-epson-escpr-en.ppd";
    ppdOptions = { PageSize = "A4"; Duplex = "DuplexNoTumble"; };
  }];

  hardware.sane = {
    enable = true;
    netConf = ''
      10.0.0.232
      brix.local
      brix.vpn
    '';
    snapshot = true;
    extraBackends = with pkgs; [ sane-airscan utsushi ];
  };

  powerManagement.enable = (lib.mkForce true);
  powerManagement.cpuFreqGovernor = (lib.mkForce null);
  powerManagement.powertop.enable = true;
}
