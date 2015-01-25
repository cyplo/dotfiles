#!/bin/bash
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install meld whois zsh tmux vim atop aria2 curl pv gajim tor torsocks nodejs

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/install_common.sh

