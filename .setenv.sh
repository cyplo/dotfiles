
export GOPATH=`realpath "$HOME/go"`
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH=$HOME/tools:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=/usr/local/heroku/bin:$PATH
export PATH=$HOME/tools/subuser/logic:$HOME/.subuser/bin:$PATH
export PATH=$HOME/.multirust/toolchains/stable/cargo/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export RUST_SRC_PATH=$HOME/dev/rust/src
export EDITOR="vim"
export KEYTIMEOUT=1
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

