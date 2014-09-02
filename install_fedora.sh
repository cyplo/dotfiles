#!/bin/bash

#software and shell
FEDORA_VERSION=`rpm -E %fedora`
sudo yum install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm
sudo yum install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm
sudo yum install vim tmux atop zsh thunderbird thunderbird-enigmail thunderbird-lightning firefox aria2 gajim lm_sensors vlc freecad python3-pip qt5-qtbase-devel qt5-qtwebkit-devel 

#ReText
aria2c http://sourceforge.net/projects/pyqt/files/sip/sip-4.16.2/sip-4.16.2.tar.gz -d /tmp
tar -C /tmp -xf /tmp/sip-4.16.2.tar.gz
cd /tmp/sip-4.16.2
python3 configure.py
make
sudo make install
aria2c http://sourceforge.net/projects/pyqt/files/PyQt5/PyQt-5.3.1/PyQt-gpl-5.3.1.tar.gz -d /tmp
tar -C /tmp -xf /tmp/PyQt-gpl-5.3.1.tar.gz
cd /tmp/PyQt-gpl-5.3.1
python3 configure.py --qmake /usr/bin/qmake-qt5
make -j8
sudo make install

sudo pip-python3 install retext

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/install_common.sh

