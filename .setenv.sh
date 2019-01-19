export TERM="xterm-256color"
export GOPATH=`realpath "$HOME/go"`

export PATH=$PATH:$HOME/.rvm/bin
export PATH=$HOME/tools:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

export RUST_SRC_PATH=$HOME/dev/rust/src
export EDITOR="vim"
export KEYTIMEOUT=1
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
