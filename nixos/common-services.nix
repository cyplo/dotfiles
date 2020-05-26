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

    restic.backups.home-to-brix = {
      passwordFile = "/etc/nixos/secrets/restic-password-brix";
      paths = [ "/home" ];
      repository = "rest:http://brix.local:8000/";
      timerConfig = { OnCalendar = "hourly"; };
      extraBackupArgs = [ "--exclude='.cache'" "--exclude='.rustup'" ];
      pruneOpts = [ "--keep-daily 8" "--keep-weekly 5" "--keep-monthly 13" "--keep-yearly 16" ];
    };

    restic.backups.home-to-b2 = {
      passwordFile = "/etc/nixos/secrets/restic-password-b2";
      paths = [ "/home" ];
      repository = "b2:cyplo-restic-foureighty:/";
      timerConfig = { OnCalendar = "hourly"; };
      extraBackupArgs = [ "--exclude='.cache'" "--exclude='.rustup'" ];
      pruneOpts = [ "--keep-daily 8" "--keep-weekly 5" "--keep-monthly 13" "--keep-yearly 16" ];
      s3CredentialsFile = "/etc/nixos/secrets/b2";
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
