{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  dotfiles = "/home/cyryl/dev/dotfiles";
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
      wirelesstools ranger xpdf apvlv unstable.xidlehook blueman
      fontconfig nodejs rustup gcc gdb
      binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy
      openjdk gimp restic glxinfo discord ghc
      unstable.notable jq awscli evince signal-desktop
      nodejs-10_x hugo mercurial terraform libreoffice
      unzip tor-browser-bundle-bin aria vlc
      jetbrains.goland jetbrains.clion jetbrains.idea-ultimate
      (wine.override { wineBuild = "wineWow"; }) winetricks
      yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
      mono calcurse calibre fbreader file python37Packages.binwalk-full
      slack discord obs-studio kpcli
    ];
    home.sessionVariables = {
      TERMINAL="alacritty";
      CM_LAUNCHER="rofi";
    };

    imports = [
      ./programs/tmux.nix
      ./programs/zsh.nix
      ./programs/vim.nix
      ./programs/alacritty.nix
      ./programs/git.nix
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

    gtk = {
      enable = true;
    };
    qt = {
      enable = true;
    };
  }
