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
      libreoffice
      mindforgerPatched.mindforger
      modem-manager-gui
      passff-host
      pdfarranger
      python38Packages.binwalk-full
      qemu aqemu
      shotwell
      simple-scan
      slack
      spotify
      unstable.ssb-patchwork
      unstable.discord
      unstable.electrum
      unstable.element-desktop
      unstable.freecad
      unstable.ghidra-bin
      unstable.hopper
      unstable.inkscape
      unstable.nyxt
      unstable.openscad
      unstable.qcad
      unstable.signal-desktop
      unstable.torbrowser
      unstable.wireshark
      vlc
      wineFull
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
