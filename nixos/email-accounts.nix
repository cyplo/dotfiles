{ config, pkgs, ... }:
{
  home-manager.users.cyryl = {...}: {
    accounts.email.accounts.cyplo = {
      primary = true;
      address = "cyplO@cyplo.dev";
      aliases = [ "cyplo@cyplo.net" ];
      realName = "Cyryl Płotnicki";
      userName = "cyplo";
    };

    home.packages = with pkgs; [
      hydroxide
      thunderbird
    ];

    systemd.user.services."hydroxide" = {
      Unit.Description = "Bridge to ProtonMail";
      Install.WantedBy = [ "default.target" ];
      Service.ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
    };

  };
}
