{ config, pkgs, ... }:

{
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
    ssb-patchwork
    passff-host
    gnome3.gnome-screenshot gsettings-desktop-schemas
    apvlv xidlehook
    fontconfig xclip gimp glxinfo
    notable mindforger
    evince signal-desktop
    libreoffice vlc
    unstable.tor-browser-bundle-bin
    jetbrains.goland unstable.jetbrains.clion jetbrains.idea-ultimate unstable.android-studio
    yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
    slack discord gnome3.nautilus gnome3.eog
    hopper
    unstable.qemu unstable.aqemu unstable.foldingathome
    spotify shotwell
  ];
}
