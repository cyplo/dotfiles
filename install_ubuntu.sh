#!/bin/bash
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y meld whois zsh tmux vim atop aria2 curl pv pixz gajim tor torsocks nodejs npm terminator gsmartcontrol python-pip mesa-utils mesa-utils-extra aptitude p7zip-full p7zip-rar thunderbird

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/install_common.sh

