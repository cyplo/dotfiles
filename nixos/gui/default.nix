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
      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
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
      mindforger
      modem-manager-gui
      passff-host
      pdfarranger
      python38Packages.binwalk-full
      qemu
      shotwell
      simple-scan
      slack
      spotify
      ssb-patchwork
      discord
      electrum
      element-desktop
      freecad
      ghidra-bin
      hopper
      inkscape
      nyxt
      openscad
      qcad
      signal-desktop
      torbrowser
      wireshark
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
