{ config, pkgs, ... }:

{
    programs.zsh = { 
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
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=238'
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
  }
