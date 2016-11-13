if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

COMPLETION_WAITING_DOTS="true"

plugins=(vi-mode svn git python zsh-syntax-highlighting history-substring-search)

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

# override prompt builder for the dir part
# render just the last dir name
prompt_dir() {
    prompt_segment blue black '%1~'
}

# aliases
if [[ `uname` == 'Darwin' ]]; then
	alias vim=/usr/local/Cellar/vim/7.4/bin/vim
fi

if [[ `uname` =~ 'CYGWIN.*' ]]; then
    export DISPLAY=:0.0
fi

alias benice="ionice -c3 nice -n20"
