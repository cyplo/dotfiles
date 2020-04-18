{ config, pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./dunst.nix
    ./autorandr.nix
    ./rofi.nix
  ];

  services = {
    picom = {
      enable = true;
      vSync = true;
    };
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    network-manager-applet.enable = true;
    pasystray.enable = true;
  };

  services.udiskie.enable = true;
  services.redshift.enable = true;
  services.redshift.provider = "geoclue2";

  home.file.".config/i3/status.toml".source = ~/dev/dotfiles/.config/i3/status-double-bat.toml;
  xsession = {
    enable = true;
  };


}
