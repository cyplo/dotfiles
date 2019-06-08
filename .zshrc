if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

COMPLETION_WAITING_DOTS="true"

plugins=(vi-mode svn git python syntax-highlighting history-substring-search spectrum sshi prompt gpg autosuggestions)

HISTFILE=~/.histfile
HISTSIZE=10240
SAVEHIST=10240
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

autoload -U compinit
compinit
setopt completealiases

zstyle ':completion::complete:*' use-cache 1

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey "^R" history-incremental-search-backward


prompt_dir() {
  prompt_segment blue $PRIMARY_FG ' %1~ '
}

if [[ `uname` =~ 'CYGWIN.*' ]]; then
    export DISPLAY=:0.0
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /home/cyryl/.travis/travis.sh ] && source /home/cyryl/.travis/travis.sh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

alias tmate="tmux detach-client -E 'tmate;tmux'"


