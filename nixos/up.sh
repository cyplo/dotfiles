#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=`realpath "$DIR/../"`

echo "linking and sourcing env"
ln -vfs "$DIR/.setenv.sh" ~/.setenv
source ~/.setenv

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
ln -vfs "$DIR/.hyper.js" ~/.hyper.js
ln -vfs "$DIR/.hyper_plugins" ~/.hyper_plugins

ln -vfs "$DIR/.Slic3r" ~/.
ln -vfs "$DIR/.ghci" ~/.
ln -vfs "$DIR/.conkyrc" ~/.
mkdir -p ~/.kde/share/config/
ln -vfs "$DIR/.kdiff3rc" ~/.kde/share/config/kdiff3rc
ln -vfs "$DIR/.gitconfig.linux.private" ~/.gitconfig
mkdir -p ~/.config/autostart/

mkdir -p ~/.config/Code/User
ln -vfs "$DIR/.config/Code/User/settings.json" ~/.config/Code/User/settings.json
ln -vfs "$DIR/.config/Code/User/keybindings.json" ~/.config/Code/User/keybindings.json
mkdir -p ~/.local/share/applications
cp -v "$DIR/keeweb.desktop" ~/.local/share/applications/
ln -vfs "$DIR/tools" ~/
mkdir -vp ~/.config/terminator
rm -f ~/.config/terminator/config
ln "$DIR/.config/terminator/config" ~/.config/terminator/config
mkdir -p ~/.cargo/
echo "all links done"

echo "adding GDB dashboard"
wget -P ~ git.io/.gdbinit

#install fonts
echo "installing fonts"
mkdir -p ~/.local/share/fonts
cp -rv "$DIR/fonts" ~/.local/share/fonts

set +e
fc-cache -rv
$SUDO fc-cache -rv
set -e

set +e
rustup update
set -e
rustup install stable
set +e
rustup install nightly
set -e
rustup default stable

(test -x "${HOME}/.cargo/bin/cargo-install-update" || nix-shell -p gcc pkgconfig zlib openssl --run "cargo install cargo-update" )
(test -x "${HOME}/.cargo/bin/rg" || cargo install ripgrep)
(test -x "${HOME}/.cargo/bin/fd" || cargo install fd-find)
(test -x "${HOME}/.cargo/bin/genpass" || cargo install genpass)

set +e
nix-shell -p gcc pkgconfig zlib openssl --run "cargo install-update -a"
set -e
nix-shell -p gcc pkgconfig zlib openssl --run "rustup run nightly cargo install-update -a"

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

GOPATH="$HOME/go"
export GOPATH=`realpath "$GOPATH"`
mkdir -p "$GOPATH"

# excercism
go get -u github.com/exercism/cli/exercism

