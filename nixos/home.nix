{ config, pkgs, ... }:

{
  programs = {
    home-manager.enable = true;
    zsh = { 
      enable = true;
      history = { 
        size = 102400;
        save = 102400;
        ignoreDups = true;
        expireDuplicatesFirst = true;
        extended = true;
        share = true; 
      };
      enableAutosuggestions = true;
      enableCompletion = true;
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
	  profileExtra = ''
		source $HOME/.setenv.sh
		'';
      sessionVariables = { TERM="xterm-256color"; EDITOR="vim"; VISUAL="vim"; PAGER="less"; };
      shellAliases = { tmate = "tmux detach-client -E 'tmate;tmux'"; };
    };
    firefox.enable = true;
    chromium.enable = true;
    alacritty.enable = true;
    go.enable = true;
    bat.enable = true;
  };
}
