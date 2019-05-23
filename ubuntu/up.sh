#!/bin/bash

set -e
set -v

sudo apt update
sudo apt -y upgrade
sudo apt -y --fix-missing install apt-file aptitude aria2 atop cmake curl git glances gnupg2 keepass2 mercurial pv python-dev python-pip python3-pip ruby-dev tmux vim whois zsh dirmngr fail2ban syncthing net-tools coreutils xclip wget

if [[ -z $USER ]]; then
    USER=`whoami`
fi

sudo usermod -aG docker $USER

curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt-get -y install syncthing

if [[ -z $NO_SYSTEMCTL ]]; then
    sudo systemctl enable docker
    sudo systemctl restart docker
    sudo systemctl enable --now syncthing@$USER.service
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$DIR/../"
DIR="$DIR" $DIR/common/up.sh
