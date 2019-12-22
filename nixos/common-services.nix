{ config, pkgs, ... }:
{
  services = {
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

    fstrim.enable = true;
    clipmenu.enable = true;

    physlock = {
      enable = true;
      allowAnyUser = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr pkgs.samsung-unified-linux-driver pkgs.splix ];
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    restic.backups.home = {
      passwordFile = "/etc/nixos/secrets/restic-password";
      paths = [ "/home" ];
      repository = "rest:http://brix.local:8000/";
      timerConfig = { OnCalendar = "hourly"; };
    };

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

      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
      };
    };
  };
}
