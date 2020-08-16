{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome3.dconf
  ];
  programs.dconf.enable = true;

  services = {
    physlock = {
      enable = true;
      allowAnyUser = true;
    };

    dbus = {
      packages = with pkgs; [ gnome2.GConf gnome3.dconf ];
      socketActivated = true;
    };

    fractalart.enable = true;
    colord.enable = true;
    xserver.windowManager.i3.enable = true;
    xserver.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };
  home-manager.users.cyryl = {...}: {
    imports = [
      ./home.nix
    ];
  };
}
