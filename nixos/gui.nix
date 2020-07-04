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
    ssb-patchwork zoom-us
    passff-host
    gnome3.gnome-screenshot gsettings-desktop-schemas
    apvlv xidlehook
    fontconfig xclip gimp glxinfo
    mindforger
    evince signal-desktop
    vlc
    jetbrains.goland jetbrains.clion jetbrains.idea-ultimate android-studio
    yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
    slack discord gnome3.nautilus gnome3.eog
    hopper
    qemu aqemu foldingathome
    spotify shotwell
    gnome-builder flatpak-builder flatpak python38Packages.lxml python38Packages.jedi meson
  ];
}
