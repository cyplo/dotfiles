#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$DIR/../"

# vim
if [[ -z $NO_COMPILE_VIM ]]; then
    VIM_BUILD_DIR=`realpath "$DIR/../"`
    echo "Vim sources location: $VIM_BUILD_DIR"
    cd "$VIM_BUILD_DIR"
    if [[ ! -d vim ]]; then
        git clone https://github.com/vim/vim.git --recursive
    else
        cd vim
        git pull
        git submodule update --init --recursive
        cd ..
    fi
    cd vim
    set +e
    sudo make uninstall
    sudo make clean
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-rubyinterp \
                --enable-python3interp=yes \
                --enable-luainterp \
                --enable-gui=no \
                --enable-cscope 
    make -j`nproc`
    sudo make install
    cd
fi
