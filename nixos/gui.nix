{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    passff-host
    gnome3.gnome-screenshot
    xpdf apvlv xidlehook blueman
    fontconfig xclip gimp glxinfo
    notable evince signal-desktop
    libreoffice unstable.tor-browser-bundle-bin vlc
    jetbrains.goland unstable.jetbrains.clion jetbrains.idea-ultimate unstable.android-studio
    yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
    slack discord obs-studio gnome3.nautilus gnome3.eog
    hopper
    (wine.override { wineBuild = "wineWow"; }) winetricks
    steam
    kicad-with-packages3d
  ];

}
