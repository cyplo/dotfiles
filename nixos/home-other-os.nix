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
(
    neovim.override {
      vimAlias = true;
      configure = {
        customRC = ''
          if filereadable($HOME . "/.vimrc")
            source $HOME/.vimrc
          endif
        '';

        vam.knownPlugins = unstable.vimPlugins;
        vam.pluginDictionaries = [
          { names = [
            "ack-vim"
            "ctrlp-vim"
            "editorconfig-vim"
            "fzf-vim"
            "nerdtree"
            "nerdtree-git-plugin"
            "rust-vim"
            "tabular"
            "vim-airline"
            "vim-airline-themes"
            "vim-autoformat"
            "vim-colors-solarized"
            "vim-dirdiff"
            "vim-dispatch"
            "vim-fugitive"
            "vim-gitgutter"
            "vim-markdown"
            "vim-nix"
            "vim-sensible"
            "vim-startify"
            "vim-surround"
            "vim-toml"
          ];
        }
      ];

    };})

      ( pass.withExtensions (ext: [ ext.pass-otp ext.pass-import ext.pass-genphrase ext.pass-audit ext.pass-update ]))
      passff-host
      cabal-install stack hsetroot lm_sensors gnome3.gnome-screenshot
      wirelesstools ranger xpdf apvlv unstable.xidlehook blueman
      fontconfig nodejs rustup gcc gdb
      binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy
      restic glxinfo ghc
      jq awscli
      mercurial terraform       unzip aria 
      mono calcurse  fbreader file python37Packages.binwalk-full
    ];

    home.sessionVariables = {
      PASSWORD_STORE_ENABLE_EXTENSIONS="true";
    };

    home.file.".vimrc".source = ~/dev/dotfiles/.vimrc.nixos;
    home.file.".config/nixpkgs/config.nix".source = ~/dev/dotfiles/nixos/shell-config.nix;
    home.file.".mozilla/native-messaging-hosts/passff.json".source = "${pkgs.passff-host}/share/passff-host/passff.json";

    imports = [
      ./programs/tmux.nix
      ./programs/zsh.nix
      ./programs/git.nix
    ];

    programs = {
      home-manager.enable = true;

      z-lua = {
        enable = true;
        enableAliases = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      rofi.enable = true;
      fzf.enable = true;
      chromium.enable = true;
      go.enable = true;
      bat.enable = true;
    };

  }
