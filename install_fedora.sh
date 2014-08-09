#!/bin/bash

#software and shell
FEDORA_VERSION=`rpm -E %fedora`
sudo yum install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm
sudo yum install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm
sudo yum install vim tmux atop zsh thunderbird thunderbird-enigmail thunderbird-lightning firefox aria2 gajim lm_sensors vlc freecad
sudo chsh -s `which zsh` $USER 
#fetch dependencies

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
git submodule init
git submodule update --recursive

#rvm
curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby

#symbolic links
ln -s "$DIR/.vim" ~/.
ln -s "$DIR/.vimrc" ~/.
ln -s "$DIR/.tmux.conf" ~/.
rm -f "$DIR/.zshrc"
ln -s "$DIR/.zshrc" ~/.
ln -s "$DIR/.oh-my-zsh" ~/.
ln -s "$DIR/.Slic3r" ~/.
ln -s "$DIR/.gitconfig.linux.private" ~/.gitconfig
ln -s "$DIR/tools" ~/

#install fonts
mkdir ~/.fonts
cp -rv "$DIR/fonts" ~/.fonts
fc-cache


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

