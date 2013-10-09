HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

bindkey -v

autoload -U compinit
compinit
setopt completealiases

autoload -U promptinit
promptinit

prompt redhat

if [[ `uname` == 'Darwin' ]]; then
	alias vim=/usr/local/Cellar/vim/7.4/bin/vim
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$HOME/tools:$PATH

