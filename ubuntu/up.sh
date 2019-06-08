#!/bin/bash

set -e
set -v

sudo apt update
sudo apt -y upgrade
sudo apt -y --fix-missing install apt-file aptitude aria2 atop cmake curl git glances gnupg2 keepass2 mercurial pv python-dev python-pip python3-pip ruby-dev tmux vim whois zsh dirmngr syncthing net-tools coreutils xclip wget scdaemon flatpak gnome-software-plugin-flatpak ufw

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# gsconnect
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload

if [[ -z $USER ]]; then
    USER=`whoami`
fi

sudo usermod -aG docker $USER

if [[ -z $NO_SYSTEMCTL ]]; then
    sudo systemctl enable docker
    sudo systemctl restart docker
    sudo systemctl enable --now syncthing@$USER.service
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$DIR/../"
DIR="$DIR" $DIR/common/up.sh
