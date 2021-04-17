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
      bisq.bisq-desktop
      keybase-gui
      unstable.electrum
      unstable.mindforger trilium-desktop typora
      digikam anarchism
      zoom-us ssb-patchwork
      passff-host
      gnome3.gnome-screenshot gsettings-desktop-schemas
      apvlv xidlehook
      fontconfig xclip gimp glxinfo
      evince unstable.signal-desktop
      vlc
      yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
      slack unstable.discord gnome3.nautilus gnome3.eog
      unstable.hopper unstable.ghidra-bin python38Packages.binwalk-full
      unstable.wireshark
      qemu aqemu
      spotify shotwell
      gnome-builder flatpak-builder flatpak python38Packages.lxml python38Packages.jedi meson
      libreoffice simple-scan
      unstable.freecad
      unstable.openscad
      unstable.inkscape
      unstable.qcad
    ];
  };
}
