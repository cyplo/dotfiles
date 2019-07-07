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
    imports = [
      ./programs/zsh.nix
      ./programs/alacritty.nix
      ];

  programs = {
    home-manager.enable = true;

    vim = {
      enable = true;
      extraConfig = builtins.readFile ~/dev/dotfiles/.vimrc.nixos;
      plugins = [
        "vim-gitgutter"
        "vim-toml"
        "vim-autoformat"
        "editorconfig-vim"
        "tabular"
        "vim-colors-solarized"
        "fzf-vim"
        "ctrlp-vim"
        "vim-nix"
        "vim-startify"
        "ack-vim"
        "vim-markdown"
        "rust-vim"
        "nerdtree"
        "vim-dispatch"
        "deoplete-nvim"
        "deoplete-go"
        "vim-fugitive"
        "vim-sensible"
        "vim-surround"
        "vim-airline"
        "vim-airline-themes"
        "vim-dirdiff"
        "nerdtree-git-plugin"
      ];
    };

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
