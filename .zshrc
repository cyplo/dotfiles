HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

autoload -U compinit
compinit
setopt completealiases


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
