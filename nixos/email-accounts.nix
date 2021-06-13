{ config, pkgs, ... }:
{
  home-manager.users.cyryl = {...}: {
    accounts.email.accounts.cyplo = {
      primary = true;
      address = "cyplo@cyplo.dev";
      aliases = [ "cyplo@cyplo.net" ];
      realName = "Cyryl Płotnicki";
      userName = "cyplo";
      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls.enable = false;
      };
      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls.enable = false;
      };
      notmuch.enable = true;
      astroid.enable = true;
      msmtp.enable = true;
      passwordCommand = "${pkgs.pass}/bin/pass proton-bridge";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      folders = {
        drafts = "drafts";
        inbox = "inbox";
        sent = "sent";
        trash = "trash";
      };
    };

    programs.mbsync.enable = true;
    programs.msmtp.enable = true;

    programs.notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
      };
    };
    programs.astroid = {
      enable = true;
      pollScript = "${pkgs.notmuch}/bin/notmuch new";
      extraConfig = {
        attachments = {
          external_open_cmd = "${pkgs.xdg_utils}/bin/xdg-open";
        };
      };
    };
    programs.alot = {
      enable = true;
    };

    home.packages = with pkgs; [
      hydroxide
    ];

    systemd.user.services."hydroxide" = {
      Unit.Description = "Bridge to ProtonMail";
      Install.WantedBy = [ "default.target" ];
      Service.ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
    };

  };
}
