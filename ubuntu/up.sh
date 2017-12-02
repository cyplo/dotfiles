#!/bin/bash

set -e
set -v

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y --fix-missing install apt-file aptitude aria2 atop cmake curl dkms freecad gajim git glances gnupg2 golang gparted gsmartcontrol intltool kdiff3 keepass2 libatk1.0-dev libbonoboui2-dev libcairo2-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libncurses5-dev libx11-dev libxpm-dev libxt-dev linux-kernel-headers lm-sensors meld mercurial nodejs npm pv python-dev python-pip python3-pip realpath retext ruby-dev silversearcher-ag solaar terminator tmux vim whois zsh dirmngr fail2ban glances atop syncthing evolution

curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt-get -y install syncthing

if [[ -z $NO_SYSTEMCTL ]]; then
    sudo systemctl enable docker
    sudo systemctl restart docker
    sudo systemctl enable fail2ban
    sudo systemctl restart fail2ban
    echo "Enabling Syncthing for $USER"
    systemctl enable syncthing@$USER.service
    systemctl restart syncthing@$USER.service
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$DIR/../"
DIR="$DIR" $DIR/common/configure_fresh_system.sh
