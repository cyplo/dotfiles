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
rm -f ~/.config/terminator/config
mkdir -p "~/.config/terminator"
ln "$DIR/.config/terminator/config" ~/.config/terminator/config

#install fonts
mkdir ~/.fonts
cp -rv "$DIR/fonts" ~/.fonts
fc-cache

#rvm
curl -sSL https://get.rvm.io | bash -s stable
source $HOME/.rvm/scripts/rvm
rvm install ruby

# talks: reveal-md
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g reveal-md

#set solarized scheme
$DIR/gnome-terminal-colors-solarized/install.sh

#setting colors to solarized should result in the default proile with the following id set
#TODO: choose the profile dynamically
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/font "'Inconsolata for Powerline Medium 18'"
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/login-shell true
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/audible-bell false
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-system-font false

echo
echo "now go ahead and restart Gnome session"

