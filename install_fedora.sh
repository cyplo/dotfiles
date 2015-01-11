#!/bin/bash

#software and shell
FEDORA_VERSION=`rpm -E %fedora`
sudo yum install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm
sudo yum install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm
sudo yum install vim tmux atop zsh thunderbird thunderbird-enigmail thunderbird-lightning firefox aria2 gajim lm_sensors vlc freecad python3-pip qt5-qtbase-devel qt5-qtwebkit-devel meld whois curl pv pixz tor torsocks nodejs npm terminator gsmartcontrol python-pip mesa-utils mesa-utils-extra aptitude p7zip-full p7zip-rar mercurial

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/install_common.sh

