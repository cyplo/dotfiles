if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

if [[ -z "$LANG" ]]; then
  export LANG='en_GB.UTF-8'
fi

typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)
export LESS='-F -g -i -M -R -S -w -X -z-4'

if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/programs:$PATH"

# other common env vars
source ~/.setenv

vacuum-repo() {
    git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d
}

vacuum-repo-hard() {
    git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D
}
