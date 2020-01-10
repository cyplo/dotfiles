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
      TERMINAL="alacritty";
      CM_LAUNCHER="rofi";
      PASSWORD_STORE_ENABLE_EXTENSIONS="true";
    };

    imports = [
      ./programs/tmux.nix
      ./programs/zsh.nix
      ./programs/alacritty.nix
      ./programs/git.nix
      ./programs/vim.nix
      ./programs.nix
      ./links.nix
      ./cli.nix
      ./gui.nix
      ./games.nix
      ./i3/home.nix
    ];

    gtk = {
      enable = true;
    };
    qt = {
      enable = true;
    };

  }
