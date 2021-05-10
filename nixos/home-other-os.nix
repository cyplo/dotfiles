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
      ./git/home.nix
      ./home-manager/programs/tmux.nix
      ./home-manager/programs/zsh.nix
      ./home-manager/links.nix
      ./home-manager/programs/vim.nix
    ];
    programs = {
      home-manager.enable = true;

      z-lua = {
        enable = true;
        enableAliases = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      gpg = {
        enable = true;
        settings = {
        };
      };
      taskwarrior.enable = true;
      fzf.enable = true;
      go.enable = true;
      bat.enable = true;
      lsd.enable = true;
      lsd.enableAliases = true;
    };
    home.packages = with pkgs; [
      aria
      atop
      bfg-repo-cleaner
      curl
      dnsutils
      docker-compose
      du-dust
      fd
      file
      fontconfig
      git
      hsetroot
      htop
      imagemagick
      jmtpfs
      jq
      ripgrep
      rustup
      terraform
      tmux
      unstable.exercism
      unstable.genpass
      unstable.topgrade
      unzip
      wget
      whois
    ];
  }
