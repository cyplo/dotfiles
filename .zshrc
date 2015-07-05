ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"

plugins=(vi-mode svn git python zsh-syntax-highlighting history-substring-search)

source $ZSH/oh-my-zsh.sh

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
else
    alias tssh="torsocks ssh"
    alias tscp="torsocks scp"
fi

# env vars
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH=$HOME/tools:$PATH
export PATH=/usr/local/heroku/bin:$PATH
export PATH=$HOME/tools/subuser/logic:$HOME/.subuser/bin:$PATH
export EDITOR="vim"
export KEYTIMEOUT=1

