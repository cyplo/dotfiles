#!/bin/bash

#software and shell
sudo yum install vim tmux atop zsh
chsh -s /bin/zsh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#symbolic links
ln -s "$DIR/.vim" ~/.
ln -s "$DIR/.vimrc" ~/.
ln -s "$DIR/.zshrc" ~/.
ln -s "$DIR/.oh-my-zsh" ~/.
ln -s "$DIR/.gitconfig.linux.private" ~/.gitconfig
ln -s "$DIR/tools" ~/

cd $DIR
git submodule init
git submodule update

$DIR/gnome-terminal-colors-solarized/install.sh

