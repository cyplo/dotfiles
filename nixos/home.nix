{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
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
      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
      };
      sessionVariables = { EDITOR="vim"; VISUAL="vim"; PAGER="less"; };
      shellAliases = { tmate = "tmux detach-client -E 'tmate;tmux'"; };
    };
    firefox.enable = true;
    chromium.enable = true;
    alacritty.enable = true;
    go.enable = true;
    bat.enable = true;
  };
}
