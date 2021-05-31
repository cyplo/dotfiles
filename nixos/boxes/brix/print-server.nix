{ config, pkgs, ... }:
{

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 631 6566 ];
  networking.firewall.allowedUDPPorts = [ 631 6566 ];
  services.printing = {
    enable = true;
    drivers = with pkgs; [ epson-escpr ];
    listenAddresses = [ "*:631" ];
    defaultShared = true;
    browsing = true;
    allowFrom = [ "all" ];
    extraConf = ''
      ServerAlias *
      DefaultEncryption Never
    '';
  };

  hardware.printers.ensurePrinters = [{
    description = "Epson XP-540";
    location = "connected to brix";
    name = "epson_xp540";
    deviceUri = "usb://EPSON/XP-540%20Series?serial=583245393030303936&interface=1";
    model = "raw";
    ppdOptions = { PageSize = "A4"; };
  }];

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ epkowa utsushi sane-airscan gawk ];
    snapshot = true;
  };

  services.udev.packages = [ pkgs.utsushi ];

  environment.systemPackages = with pkgs; [ gawk ];
  services.saned = {
    enable = true;
    extraConfig = ''
      10.0.0.0/24
      172.23.153.159
      172.23.28.139
      172.23.206.88
      [fd77:8f2a:9a44::1]/60
    '';
  };

}
