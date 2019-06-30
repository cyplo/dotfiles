{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };
  home.packages = with pkgs; [
      keepass fontconfig nodejs rustup gcc gdb
      binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy
      gnome3.gnome-shell-extensions chrome-gnome-shell gnomeExtensions.clipboard-indicator
      gnomeExtensions.caffeine gnomeExtensions.no-title-bar
      openjdk11 gimp restic glxinfo discord steam
      zoom-us
      nodejs-10_x hugo mercurial terraform libreoffice
      unzip tor-browser-bundle-bin aria vlc
      jetbrains.goland jetbrains.clion
      (wine.override { wineBuild = "wineWow"; }) winetricks
      yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
      mono calcurse calibre fbreader file python37Packages.binwalk-full
    ];
  programs = {
    home-manager.enable = true;

    zsh = { 
      enable = true;
      history = { 
        size = 102400;
        save = 102400;
        ignoreDups = true;
        expireDuplicatesFirst = true;
        share = true; 
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "vi-mode" "git" "python" "syntax-highlighting" "history-substring-search" "spectrum" "sshi" "prompt" "gpg" "autosuggestions" "tmux" ];
      };
	  plugins = [
		  {
			name = "spaceship";
			file = "spaceship.zsh";
			src = pkgs.fetchgit {
			  url = "https://github.com/denysdovhan/spaceship-prompt";
			  rev = "v3.11.1";
			  sha256 = "0habry3r6wfbd9xbhw10qfdar3h5chjffr5pib4bx7j4iqcl8lw8";
			};
	  }];
      initExtra = ''
        SPACESHIP_TIME_SHOW=true
        SPACESHIP_EXIT_CODE_SHOW=true
        SPACESHIP_VI_MODE_SHOW=false
        SPACESHIP_BATTERY_THRESHOLD=30
        setopt HIST_IGNORE_ALL_DUPS
        '';
      profileExtra = ''
        export PATH="$HOME/programs:$PATH";
        export PATH="$HOME/tools:$PATH";
        export PATH="$HOME/bin:$PATH";
        export PATH="$HOME/.local/bin:$PATH";
        export PATH="$GOPATH/bin:$PATH";
        export PATH="$HOME/.rvm/bin:$PATH";
        export PATH="$HOME/.cargo/bin:$PATH";
        export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH";
        '';
      sessionVariables = { 
        TERM="xterm-256color"; 
        EDITOR="vim";
        VISUAL="vim";
        PAGER="less";
        ZSH_TMUX_AUTOSTART=true;
        GOPATH="$HOME/go";
      };
      shellAliases = { tmate = "tmux detach-client -E 'tmate;tmux'"; cat = "bat"; };
    };

    alacritty = {
      enable = true;
      settings = {
        window.decorations = "none";
        window.startup_mode = "Fullscreen";

        scrolling = {
          history = 32000;
          multiplier = 3;
          faux_multiplier = 3;
          auto_scroll = false;
        };

        tabspaces = 4;

        font = {
          family = "DejaVu Sans Mono for Powerline";
          size = 12.0;
        };

        draw_bold_text_with_bright_colors = true;

        colors = { 
          primary = {
            background= "0x002b36";
            foreground= "0x839496";
            
          };

          normal = {
            black=   "0x073642";
            red=     "0xdc322f";
            green=   "0x859900";
            yellow=  "0xb58900";
            blue=    "0x268bd2";
            magenta= "0xd33682";
            cyan=    "0x2aa198";
            white=   "0xeee8d5";
          };

          bright = {
            black=   "0x002b36";
            red=     "0xcb4b16";
            green=   "0x586e75";
            yellow=  "0x657b83";
            blue=    "0x839496";
            magenta= "0x6c71c4";
            cyan=    "0x93a1a1";
            white=   "0xfdf6e3";
          };

        background_opacity= 1.0;
        dynamic_title= true;
      };
        cursor= {
          style = "Block";
          unfocused_hollow= true;
        };
        live_config_reload= true;
      };
    };

    fzf.enable = true;
    tmux = {
      enable = true;
      shortcut = "a";
      extraConfig = ''
        set -g status off
        '';
    };
    firefox.enable = true;
    chromium.enable = true;
    go.enable = true;
    bat.enable = true;
  };
}
