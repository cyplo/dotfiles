#!/usr/bin/env bash

set -e
set -o pipefail

SUDO=""
if [[ -z $NOSUDO ]]; then
    SUDO="sudo"
fi

echo
echo "configuring settings common among OSes"
echo "using '$SUDO' as sudo"
$SUDO true

echo "linking and sourcing env"
ln -vfs "$DIR/.setenv.sh" ~/.setenv
source ~/.setenv

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
ln -vfs "$DIR/.ideavimrc" ~/.
ln -vfs "$DIR/.vimrc" ~/.vimrc
ln -vfs "$DIR/rvmrc" ~/.rvmrc
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
ln -vfs "$DIR/.hyper_plugins" ~/.hyper_plugins

ln -vfs "$DIR/.Slic3r" ~/.
ln -vfs "$DIR/.ghci" ~/.
ln -vfs "$DIR/.conkyrc" ~/.
mkdir -p ~/.kde/share/config/
ln -vfs "$DIR/.kdiff3rc" ~/.kde/share/config/kdiff3rc

ln -vfs "$DIR/.gitconfig.linux.private" ~/.gitconfig
if [[ `hostname` =~ .*FORM3.* ]]; then
    ln -vfs "$DIR/.gitconfig.linux.form3" ~/.gitconfig
fi

mkdir -p ~/.config/autostart/
# autostart apps
mkdir -p ~/.config/vdirsyncer/
ln -vfs "$DIR/.config/vdirsyncer/config" ~/.config/vdirsyncer/
mkdir -p ~/.config/Code/User
ln -vfs "$DIR/.config/Code/User/settings.json" ~/.config/Code/User/settings.json
ln -vfs "$DIR/.config/Code/User/keybindings.json" ~/.config/Code/User/keybindings.json
mkdir -p ~/.local/share/applications
cp -v "$DIR/keeweb.desktop" ~/.local/share/applications/
ln -vfs "$DIR/tools" ~/
mkdir -vp ~/.config/terminator
rm -f ~/.config/terminator/config
ln "$DIR/.config/terminator/config" ~/.config/terminator/config
mkdir -vp "$HOME/.config/alacritty/"
ln -vfs "$DIR/.alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
mkdir -p ~/.cargo/
echo "all links done"

echo "adding GDB dashboard"
wget -P ~ git.io/.gdbinit

echo "adding NVM"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

echo "using NVM"
set +e
\. "$NVM_DIR/nvm.sh"
set -e
nvm install node
nvm use node

#install fonts
echo "installing fonts"
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

    set +e
    rustup update
    set -e
    rustup install stable
    set +e
    rustup install nightly
    set -e
    rustup default stable

    rustup component add rls --toolchain stable
    rustup component add clippy --toolchain stable
    rustup component add rustfmt --toolchain stable
    rustup component add rust-analysis --toolchain stable
    rustup component add rust-src --toolchain stable

    set +e
    rustup component add rls --toolchain nightly
    rustup component add clippy --toolchain nightly
    rustup component add rustfmt --toolchain nightly
    rustup component add rust-analysis --toolchain nightly
    rustup component add rust-src --toolchain nightly
    set -e

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

    (test -x "${HOME}/.cargo/bin/cargo-install-update" || cargo install cargo-update)
    (test -x "${HOME}/.cargo/bin/rg" || cargo install ripgrep)
    (test -x "${HOME}/.cargo/bin/fd" || cargo install fd-find)
    (test -x "${HOME}/.cargo/bin/genpass" || cargo install genpass)

    set +e
    cargo install-update -a
    set -e
    rustup run nightly cargo install-update -a
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

echo "Getting GPG keys.."
for key in \
    409B6B1796C275462A1703113804BB82D39DC0E3 \
    7D2BAF1CF37B13E2069D6956105BD0E739499BDB
do
    $GPG --keyserver hkp://keys.gnupg.net --recv-keys "$key" || \
    $GPG --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    $GPG --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    $GPG --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" \
    ;
done

if [[ -z $NORUBY ]]; then
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
    if [[ -z $NO_GO ]]; then
        echo "Installing fzf"
        ~/.fzf/install --64 --all
    fi
    echo "Installing Vim plugins"
    echo "\n" | vim +PlugClean! +qa
    echo "\n" | vim +PlugInstall! +qa
fi

if [[ -z $NO_GO ]]; then
    GOPATH="$HOME/go"
    export GOPATH=`realpath "$GOPATH"`
    mkdir -p "$GOPATH"

    # excercism
    go get -u github.com/exercism/cli/exercism
fi

nvm use node
npm install -g reveal-md
npm install -g diff-so-fancy
npm install -g cssnano

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
    set +e
    $SUDO $PIP install --upgrade pip setuptools
    $SUDO $PIP install --upgrade packaging
    set -e
    echo "Installing Nikola"
    $SUDO $PIP install --upgrade pygments-style-solarized ws4py watchdog webassets Nikola aiohttp
    echo "Installing vim dependencies"
    $SUDO $PIP install neovim
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


