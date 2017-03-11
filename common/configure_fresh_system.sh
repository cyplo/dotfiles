#!/bin/bash

SUDO=""
if [[ -z $NOSUDO ]]; then
    SUDO="sudo"
fi

echo "using '$SUDO' as sudo"

set -e
echo
echo "configuring settings common among OSes"
$SUDO true

#zsh
if [[ -z $DONT_CHANGE_SHELL ]]; then
    echo "changing shell to zsh"
    chsh -s `which zsh` $USER 
fi

CURL="curl -sSfL"

if [[ -z $DIR ]]; then
    echo "please set DIR"
    exit 1
fi

DIR=`realpath $DIR`
echo "using $DIR as the top level directory"
cd $DIR
git submodule update --init --recursive

#configs
ln -vfs "$DIR/.vim" ~/.
ln -vfs "$DIR/.vimrc.linux" ~/.vimrc
ln -vfs "$DIR/.tmux.conf" ~/.
ln -vfs "$DIR/.tmux.macosx" ~/.
rm -f "~/.zshrc"
ln -vfs "$DIR/.zprezto" ~/.
ln -vfs "$DIR/.zpreztorc" ~/.zpreztorc
ln -vfs "$DIR/.zprofile" ~/.zprofile
ln -vfs "$DIR/.zprezto/runcoms/zshenv" ~/.zshenv
ln -vfs "$DIR/.zshrc" ~/.zshrc
ln -vfs "$DIR/.hyper.js" ~/.hyper.js
ln -vfs "$DIR/.hyper_plugins" ~/.hyper_plugins

ln -vfs "$DIR/.setenv.sh" ~/.setenv
ln -vfs "$DIR/.Slic3r" ~/.
ln -vfs "$DIR/.ghci" ~/.
ln -vfs "$DIR/.conkyrc" ~/.
mkdir -p ~/.kde/share/config/
ln -vfs "$DIR/.kdiff3rc" ~/.kde/share/config/kdiff3rc
ln -vfs "$DIR/.gitconfig.linux.private" ~/.gitconfig
mkdir -p ~/.config/autostart/
# autostart apps
ln -vfs "$DIR/.config/autostart/redshift-gtk.desktop" ~/.config/autostart/
mkdir -p ~/.config/vdirsyncer/
ln -vfs "$DIR/.config/vdirsyncer/config" ~/.config/vdirsyncer/
ln -vfs "$DIR/.config/redshift.conf" ~/.config/redshift.conf
mkdir -p ~/.config/Code/User
ln -vfs "$DIR/.config/Code/User/settings.json" ~/.config/Code/User/settings.json

source ~/.setenv

# symlink 'nodejs' as node on some systems
# will replace symlink if it exists, but won't replace regular file
if [[ ! -f /usr/bin/node ]]; then
    if [[ -f /usr/bin/nodejs ]]; then
        $SUDO ln -vfs /usr/bin/nodejs /usr/bin/node
    fi
fi

# tools
ln -vfs "$DIR/tools" ~/

# stuff that does not like symbolic links
mkdir -vp ~/.config/terminator
rm -f ~/.config/terminator/config
ln "$DIR/.config/terminator/config" ~/.config/terminator/config

#install fonts
mkdir -p ~/.fonts
cp -rv "$DIR/fonts" ~/.fonts
set +e
fc-cache -rv
$SUDO fc-cache -rv
set -e

if [[ -z $NORUST ]]; then
    #rust
    echo "installing rust"
    RUSTUP_TEMP="/tmp/blastoff.sh"
    $CURL https://sh.rustup.rs > "$RUSTUP_TEMP"
    chmod a+x "$RUSTUP_TEMP"
    "$RUSTUP_TEMP" -y
    rm -f "$RUSTUP_TEMP"
    rustup update
    rustup default stable
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
    cd "$DIR/../"
    echo "getting rust sources..."
    if [[ ! -d rust ]]; then
        git clone https://github.com/rust-lang/rust.git --recursive
    else
        cd rust 
        git pull
        git submodule update --init --recursive
    fi
set +e
    cargo install rustfmt
    cargo install racer
    cargo install rustsym
    cargo install ripgrep

    cd "$DIR/../"
    if [[ ! -d alacritty ]]; then
        git clone https://github.com/jwilm/alacritty.git --recursive
        cd alacritty
    else
        cd alacritty 
        git pull
        git submodule update --init --recursive
    fi
    rustup override set stable
    cargo install
set -e
fi

set +e
echo "Querying for gpg2 path"
gpg2_path=`which gpg2`
echo "Got $gpg2_path for gpg2 path"
set -e
if [[ -x "$gpg2_path" ]]; then 
    echo "Using gpg2"
    GPG=gpg2
else
    echo "WARNING using gpg instead of gpg2"
    GPG=gpg
fi

if [[ -z $NORUBY ]]; then
    set +e
    $GPG --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    set -e
    $GPG --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    echo "Downloading RVM..."
    $CURL https://get.rvm.io | bash
    set +e
    echo "Sourcing RVM..."
    source /usr/local/rvm/scripts/rvm
    source ~/.rvm/scripts/rvm
    set -e
    echo "Installing Ruby..."
    rvm install ruby --disable-binary
fi

if [[ -z $NOVIM ]]; then
    if [[ ! -d ~/.fzf ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    else
        cd ~/.fzf
        git pull
        git submodule update --init --recursive
    fi
    echo "Installing fzf"
    ~/.fzf/install --64 --all
    echo "Installing Vim plugins"
    echo "\n" | vim +PluginInstall! +qa

    if [[ -z $NOYCM ]]; then
        echo "configuring YouCompleteMe"
        cd ~/.vim/bundle/YouCompleteMe
        git submodule update --init --recursive
        if [[ -z $NOPYTHON3 ]]; then
            python3 ./install.py --clang-completer --racer-completer --tern-completer
        else
            python ./install.py --clang-completer --racer-completer --tern-completer
        fi
    fi
fi

if [[ -z $NO_GO ]]; then
    GOPATH="$HOME/go"
    export GOPATH=`realpath "$GOTPATH"`
    mkdir -p "$GOPATH"

    # excercism
    go get -u github.com/exercism/cli/exercism
fi

echo "Installing Reveal-md"
# talks: reveal-md
$SUDO npm install -g reveal-md
echo "Installing fancy differ"
$SUDO npm install -g diff-so-fancy

if [[ -z $NOPYTHON3 ]]; then
    set +e
    pip3_path=`which pip3`
    set -e
    echo "pip3 path is $pip3_path"
    if [[ -x "$pip3_path" ]]; then
        echo "Choosing pip3 for pip"
        PIP=pip3
    else
        echo "Choosing pip"
        PIP=pip
    fi
    echo "Upgrading pip"
    $SUDO $PIP install --upgrade pip setuptools
    $SUDO $PIP install --upgrade packaging
    echo "Installing Nikola"
    $SUDO $PIP install --upgrade pygments-style-solarized ws4py watchdog webassets Nikola
fi

if [[ -z $USER ]]; then
    USER=`whoami`
fi

# normalize npm permissions
mkdir -p $HOME/.npm
$SUDO chown -R $USER $HOME/.npm

echo
echo "now go ahead and restart"
echo


