{ config, pkgs, ... }:

{
  home-manager.users.cyryl = {...}: {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
    };
    qt = {
      enable = true;
      platformTheme = "gnome";
    };

    imports = [
      ./vscode.nix
    ];

    home.packages = with pkgs; [
      anarchism
      apvlv
      bisq.bisq-desktop
      digikam
      evince
      fontconfig
      gimp
      glxinfo
      gnome3.eog
      gnome3.gnome-screenshot
      gnome3.nautilus
      gsettings-desktop-schemas
      keybase-gui
      libreoffice simple-scan
      passff-host
      python38Packages.binwalk-full
      qemu aqemu
      slack
      spotify shotwell
      ssb-patchwork
      unstable.discord
      unstable.electrum
      unstable.freecad
      unstable.ghidra-bin
      unstable.hopper
      unstable.inkscape
      unstable.mindforger
      unstable.openscad
      unstable.qcad
      unstable.signal-desktop
      unstable.wireshark
      vlc
      xclip
      xidlehook
      yubico-piv-tool
      yubikey-manager-qt
      yubikey-personalization
      yubikey-personalization-gui
      zoom-us
    ];
  };
}
