#!/bin/bash

SUDO=""
if [[ -z $NOSUDO ]]; then
    SUDO="sudo"
fi

echo "using '$SUDO' as sudo"

set -e
$SUDO true

CURL="curl -sSfL"

if [[ -z $DIR ]]; then
    echo "please set DIR"
    exit 1
fi

DIR=`realpath $DIR`
echo "using $DIR as the top level directory"
cd $DIR

source ~/.setenv

#rust
echo "installing rust"
RUSTUP_TEMP="/tmp/blastoff.sh"
$CURL https://sh.rustup.rs > "$RUSTUP_TEMP"
chmod a+x "$RUSTUP_TEMP"
"$RUSTUP_TEMP" -y
rm -f "$RUSTUP_TEMP"
rustup update
rustup default stable
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
cd "$DIR/../"
echo "getting rust sources..."
if [[ ! -d rust ]]; then
    git clone https://github.com/rust-lang/rust.git --recursive
else
    cd rust 
    git pull
    git submodule update --init --recursive
fi

cd "$DIR/../"
if [[ ! -d alacritty ]]; then
    git clone https://github.com/jwilm/alacritty.git --recursive
    cd alacritty
else
    cd alacritty 
    git pull
    git submodule update --init --recursive
fi
rustup override set `cat rustc-version`
cargo install

set +e
echo "Querying for gpg2 path"
gpg2_path=`which gpg2`
echo "Got $gpg2_path for gpg2 path"
set -e
if [[ -x "$gpg2_path" ]]; then 
    echo "Using gpg2"
    GPG=gpg2
else
    echo "WARNING using gpg instead of gpg2"
    GPG=gpg
fi

set +e
$GPG --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
set -e
$GPG --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
echo "Downloading RVM..."
$CURL https://get.rvm.io | bash
set +e
echo "Sourcing RVM..."
source /usr/local/rvm/scripts/rvm
source ~/.rvm/scripts/rvm
set -e
echo "Installing Ruby..."
rvm install 2.3.1 --disable-binary

