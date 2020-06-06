#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=`realpath "$DIR/../"`

if [[ -z $DIR ]]; then
    echo "please set DIR"
    exit 1
fi

HOST=`hostname`
DIR=`realpath $DIR`
echo "using $DIR as the top level directory"
cd $DIR
git submodule update --init --recursive

mkdir -p ~/.config/Code/User
ln -vfs "$DIR/.config/Code/User/settings.json" ~/.config/Code/User/settings.json
ln -vfs "$DIR/.config/Code/User/keybindings.json" ~/.config/Code/User/keybindings.json
mkdir -p ~/.local/share/applications
ln -vfs "$DIR/tools" ~/
ln -vsf "$DIR/nixos/boxes/$HOST/home.nix" ~/.config/nixpkgs/home.nix
sudo ln -vsf "$DIR/nixos/boxes/$HOST/configuration.nix" /etc/nixos/configuration.nix
echo "all links done"

sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

