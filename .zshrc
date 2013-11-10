HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

bindkey -v

autoload -U compinit
compinit
setopt completealiases

autoload -U comptinit promptinit
compinit
promptinit

#default, should be everywhere
prompt redhat

prompt -l | grep -i gentoo > /dev/null
code=$?
if [[ $code == 0 ]]; then
    prompt gentoo
fi

zstyle ':completion::complete:*' use-cache 1
if [[ `uname` == 'Darwin' ]]; then
	alias vim=/usr/local/Cellar/vim/7.4/bin/vim
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$HOME/tools:$PATH

