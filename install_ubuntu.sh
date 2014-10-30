#!/bin/bash
sudo apt-get update
sudo apt-get full-upgrade
sudo apt-get install meld whois zsh tmux vim atop aria2 curl pv pixz gajim tor torsocks nodejs npm

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/install_common.sh

