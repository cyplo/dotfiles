{ config, pkgs, ... }:
let
  extraArgs = [ "--exclude='.cache'" "--exclude='.rustup'" "--exclude='.cargo'" "--exclude '.local/share'" ];
in
  {

    services = {
      restic.backups.home-to-brix = {
        passwordFile = "/etc/nixos/secrets/restic-password-brix";
        paths = [ "/home" ];
        repository = "rest:http://brix:8000/";
        timerConfig = { OnCalendar = "hourly"; };
        extraBackupArgs = extraArgs;
      };

      restic.backups.home-to-b2 = {
        passwordFile = "/etc/nixos/secrets/restic-password-b2";
        paths = [ "/home" ];
        repository = "b2:cyplo-restic-foureighty:/";
        timerConfig = { OnCalendar = "hourly"; };
        extraBackupArgs = extraArgs;
        s3CredentialsFile = "/etc/nixos/secrets/b2";
      };
    };
  }
