#!/bin/bash

#zsh
sudo chsh -s `which zsh` $USER 

#submodules
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
git submodule init
git submodule update --recursive


#symbolic links
ln -vfs "$DIR/.vim" ~/.
ln -vfs "$DIR/.vimrc" ~/.
ln -vfs "$DIR/.tmux.conf" ~/.
rm -f "~/.zshrc"
ln -vfs "$DIR/.zshrc" ~/.
ln -vfs "$DIR/.oh-my-zsh" ~/.
ln -vfs "$DIR/.Slic3r" ~/.
ln -vfs "$DIR/.gitconfig.linux.private" ~/.gitconfig
ln -vfs "$DIR/tools" ~/

# stuff that does not like symbolic links
mkdir -vp ~/.config/terminator
rm -f ~/.config/terminator/config
ln "$DIR/.config/terminator/config" ~/.config/terminator/config

#install fonts
mkdir ~/.fonts
cp -rv "$DIR/fonts" ~/.fonts
fc-cache

#rvm
gpg --recv-keys BF04FF17
curl -sSL https://get.rvm.io | bash -s stable
source $HOME/.rvm/scripts/rvm
rvm install ruby

# talks: reveal-md
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g reveal-md

echo
echo "now go ahead and restart Gnome session"

