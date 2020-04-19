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

    home.sessionVariables = {
    };

    targets.genericLinux.enable = true;
    home.file.".gitconfig".source = ~/dev/dotfiles/.gitconfig.linux.form3;
    home.file.".config/i3/status.toml".source = ~/dev/dotfiles/.config/i3/status-single-bat.toml;

    imports = [
      ./home-common.nix
    ];
  }
