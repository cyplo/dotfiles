{ config, pkgs, ... }:
{

  services = {
    restic.backups.home-to-brix = {
      passwordFile = "/etc/nixos/secrets/restic-password-brix";
      paths = [ "/home" ];
      repository = "rest:http://brix.local:8000/";
      timerConfig = { OnCalendar = "hourly"; };
      extraBackupArgs = [ "--exclude='.cache'" "--exclude='.rustup'" ];
      pruneOpts = [ "--keep-hourly 25" "--keep-daily 8" "--keep-weekly 5" "--keep-monthly 13" "--keep-yearly 16" ];
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
  };
}
