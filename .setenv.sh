export TERM="xterm-256color"

export PATH="$HOME/programs:$PATH"
export PATH="$HOME/tools:$PATH"
export PATH="$HOME/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export GOPATH=`realpath "$HOME/go"`
export PATH="$GOPATH/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export EDITOR="vim"
export KEYTIMEOUT=1
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export NVM_DIR="$HOME/.nvm"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval $(luarocks path --bin)
