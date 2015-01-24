ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

COMPLETION_WAITING_DOTS="true"

plugins=(vi-mode svn git python history-substring-search)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
HISTFILE=~/.histfile
HISTSIZE=10240
SAVEHIST=10240
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

autoload -U compinit
compinit
setopt completealiases

zstyle ':completion::complete:*' use-cache 1

if [[ `uname` == 'Darwin' ]]; then
	alias vim=/usr/local/Cellar/vim/7.4/bin/vim
fi

if [[ `uname` =~ 'CYGWIN.*' ]]; then
    export DISPLAY=:0.0
else
    alias tssh="torsocks ssh"
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH=$HOME/tools:$PATH
export PATH=/usr/local/heroku/bin:$PATH
export EDITOR="vim"
export KEYTIMEOUT=1

