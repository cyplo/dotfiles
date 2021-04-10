{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz;
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

    home.sessionVariables = {
      LOCALE_ARCHIVE=/usr/lib/locale/locale-archive;
    };

    targets.genericLinux.enable = true;
    home.file.".gitconfig".source = ~/dev/dotfiles/.gitconfig.linux.form3;

    imports = [
      ./home-manager/default.nix
      ./git/home.nix
      ./mercurial/home.nix
    ];
  }
