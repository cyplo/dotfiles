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
      fontconfig kpcli
    ];
    home.sessionVariables = {
      TERMINAL="alacritty";
    };

    imports = [
      ./programs/tmux.nix
      ./programs/zsh.nix
      ./programs/alacritty.nix
      ./programs/git.nix
    ];

    programs = {
      home-manager.enable = true;

      fzf.enable = true;
      firefox.enable = true;
      chromium.enable = true;
      go.enable = true;
      bat.enable = true;
    };
  }
