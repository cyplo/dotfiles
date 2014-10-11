#!/bin/bash
sudo apt-get update
sudo apt-get dist-ugprade
sudo apt-get install meld whois zsh tmux vim atop aria2 curl pv pixz

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/install_common.sh

