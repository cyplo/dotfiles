#!/bin/bash

set -e
set -v

sudo apt update
sudo apt -y upgrade
sudo apt -y --fix-missing install apt-file aptitude git curl flatpak i3

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

curl https://nixos.org/nix/install | sh

source /home/cyryl/.nix-profile/etc/profile.d/nix.sh
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

nix-channel --add https://github.com/rycee/home-manager/archive/release-19.09.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

ln -vfs $HOME/dev/dotfiles/nixos/home-other-os.nix $HOME/.config/nixpkgs/home.nix

home-manager switch
sudo chsh -s /home/cyryl/.nix-profile/bin/zsh cyryl


