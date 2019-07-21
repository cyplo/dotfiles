{ config, pkgs, ... }:
{
  services = {
    fwupd.enable = true;
    tlp.enable = true;
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
      repository = "sftp:fetcher@brix:/mnt/data/backup-targets";
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

      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
      };
    };
  };
}
