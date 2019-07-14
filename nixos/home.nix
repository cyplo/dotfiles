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
      keepass fontconfig nodejs rustup gcc gdb
      binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy
      gnome3.gnome-shell-extensions chrome-gnome-shell gnomeExtensions.clipboard-indicator
      gnomeExtensions.caffeine gnomeExtensions.no-title-bar
      openjdk11 gimp restic glxinfo discord steam
      zoom-us unstable.notable
      nodejs-10_x hugo mercurial terraform libreoffice
      unzip tor-browser-bundle-bin aria vlc
      jetbrains.goland jetbrains.clion
      (wine.override { wineBuild = "wineWow"; }) winetricks
      yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
      mono calcurse calibre fbreader file python37Packages.binwalk-full
    ];
    home.sessionVariables = {
      TERMINAL="alacritty";
    };
    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config.modifier = "Mod4";
      };
    };
    imports = [
      ./programs/zsh.nix
      ./programs/vim.nix
      ./programs/alacritty.nix
    ];

    programs = {
      home-manager.enable = true;

      fzf.enable = true;
      tmux = {
        enable = true;
        shortcut = "a";
        extraConfig = ''
          set -g status off
          set -g mouse on
        '';
      };
      firefox.enable = true;
      chromium.enable = true;
      go.enable = true;
      bat.enable = true;
    };
  }
