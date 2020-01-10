{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    passff-host
    gnome3.gnome-screenshot
    xpdf apvlv xidlehook blueman
    fontconfig xclip gimp glxinfo
    notable evince signal-desktop
    libreoffice vlc
    jetbrains.goland unstable.jetbrains.clion jetbrains.idea-ultimate unstable.android-studio
    yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
    slack discord obs-studio gnome3.nautilus gnome3.eog
    hopper
    unstable.qemu unstable.aqemu
  ];

}
