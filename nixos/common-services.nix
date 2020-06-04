{ config, pkgs, ... }:
{
  docker-containers.meditate = {
    image = "meditate";
    ports = [ "80:80" ];
  };

  services = {
    udev.packages = [ pkgs.android-udev-rules ];
    ratbagd.enable = true;

    fwupd = {
      enable = true;
      package = pkgs.fwupd;
    };

    tlp = {
      enable = true;
      extraConfig = ''
          DISK_IOSCHED="mq-deadline"
      '';
    };

    upower.enable = true;
    fstrim.enable = true;
    clipmenu.enable = true;
    lorri.enable = true;

    avahi = {
      enable = true;
      nssmdns = true;
    };


    geoclue2.enable = true;
    xserver = {
      enable = true;
      layout = "pl";
      libinput = {
        enable = true;
        naturalScrolling = false;
        clickMethod = "clickfinger";
      };

      useGlamor = true;

      deviceSection = ''
          Option "TearFree" "true"
          Option "AccelMethod" "sna"
      '';

    };
  };
}
