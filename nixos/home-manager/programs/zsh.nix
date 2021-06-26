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
      plugins = [ "vi-mode" "git" "python" "history-substring-search" "tmux" ];
    };
    initExtra = ''
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
    envExtra = ''
        [ -s "/home/cyryl/.jabba/jabba.sh" ] && source "/home/cyryl/.jabba/jabba.sh"
        tmux source-file ~/.config/tmux/tmux.conf
        local nixos_version=`which nixos-version`
        if [[ ! -x "$nixos_version" ]]; then
          source /home/cyryl/.nix-profile/etc/profile.d/nix.sh
          export NIX_PATH="$HOME/.nix-defexpr/channels:$NIX_PATH"
          export NVM_DIR="$HOME/.nvm"
          [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
          echo "non-nixos patches loaded"
        fi
    '';
    sessionVariables = {
      TERM="xterm-256color";
      EDITOR="vim";
      VISUAL="vim";
      PAGER="less";
      ZSH_TMUX_AUTOSTART=true;
      GOPATH="$HOME/go";
    };
    shellAliases = {
      tmate = "tmux detach-client -E 'tmate;tmux'";
      cat = "bat -p";
      rg = "rga";
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      enableFlakes= true;
    };
  };

  home.file.".config/starship.toml".text =''
      [aws]
      disabled = true

      [battery]
      full_symbol = ""
      charging_symbol = ""
      discharging_symbol = ""

      [[battery.display]]
      threshold = 10
      style = "bold red"

      [[battery.display]]
      threshold = 30
      style = "bold yellow"

      [memory_usage]
      disabled = false

      [git_branch]
      symbol = "git "

      [hg_branch]
      symbol = "hg "

      [nix_shell]
      symbol = "nix-shell "
  '';

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
