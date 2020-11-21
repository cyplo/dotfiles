{ config, pkgs, ... }:
{
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
          ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
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
      settings = {
        "DISK_IOSCHED" = "mq-deadline";
      };
    };

    upower.enable = true;
    fstrim.enable = true;
    clipmenu.enable = true;
    lorri.enable = true;
    i2pd = {
      enable = true;
      bandwidth = 2500; # kb/s
      proto.http.enable = true;
      proto.httpProxy.enable = true;
      addressbook.subscriptions = [
        "http://inr.i2p/export/alive-hosts.txt"
        "http://i2p-projekt.i2p/hosts.txt"
        "http://stats.i2p/cgi-bin/newhosts.txt"
        "http://identiguy.i2p/hosts.txt"
      ];
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    geoclue2.enable = true;
    xserver = {
      enable = true;
      layout = "pl";
      xkbOptions = "caps:ctrl_modifier";
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
