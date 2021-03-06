{ config, pkgs, ... }:
{
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
    keybase.enable=true;

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
        touchpad = {
          naturalScrolling = false;
          clickMethod = "clickfinger";
          disableWhileTyping = true;
        };
      };

      useGlamor = true;

      deviceSection = ''
          Option "TearFree" "true"
          Option "AccelMethod" "sna"
      '';

    };
  };
}
