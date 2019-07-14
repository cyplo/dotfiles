{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
  {
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };
    };
    home.packages = with pkgs; [
      wirelesstools
      keepass fontconfig nodejs rustup gcc gdb
      binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy
      openjdk11 gimp restic glxinfo discord
      unstable.notable
      nodejs-10_x hugo mercurial terraform libreoffice
      unzip tor-browser-bundle-bin aria vlc
      jetbrains.goland jetbrains.clion
      (wine.override { wineBuild = "wineWow"; }) winetricks
      yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
      mono calcurse calibre fbreader file python37Packages.binwalk-full
    ];
    home.sessionVariables = {
      TERMINAL="alacritty";
      GDK_SCALE="2";
      QT_AUTO_SCREEN_SCALE_FACTOR="1";
    };

    imports = [
      ./programs/tmux.nix
      ./programs/zsh.nix
      ./programs/vim.nix
      ./programs/alacritty.nix
      ./user-xsession.nix
    ];

    programs = {
      home-manager.enable = true;

      rofi.enable = true;
      fzf.enable = true;
      firefox.enable = true;
      chromium.enable = true;
      go.enable = true;
      bat.enable = true;
    };
  }
