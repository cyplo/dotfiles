#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=`realpath "$DIR/../"`

CURL="curl -sSfL"

if [[ -z $DIR ]]; then
    echo "please set DIR"
    exit 1
fi

DIR=`realpath $DIR`
echo "using $DIR as the top level directory"
cd $DIR
git submodule update --init --recursive

ln -vfs "$DIR/.gitconfig.linux.private" ~/.gitconfig

mkdir -p ~/.config/Code/User
ln -vfs "$DIR/.config/Code/User/settings.json" ~/.config/Code/User/settings.json
ln -vfs "$DIR/.config/Code/User/keybindings.json" ~/.config/Code/User/keybindings.json
mkdir -p ~/.local/share/applications
cp -v "$DIR/keeweb.desktop" ~/.local/share/applications/
ln -vfs "$DIR/tools" ~/
echo "all links done"

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

nix-channel --add https://github.com/rycee/home-manager/archive/release-19.03.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

