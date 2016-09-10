#!/bin/bash

DOTFILES_PATH="$HOME/dev/dotfiles"
mkdir -pv $HOME/dev/
rm -fr $DOTFILES_PATH

git clone "$OUTER_CLONE" "$DOTFILES_PATH"
cd "$DOTFILES_PATH"
git remote set-url origin git@github.com:cyplo/dotfiles.git
git checkout $branch

export NOSUDO=true
export DONT_CHANGE_SHELL=true
export NORUST=true
export NORUBY=true
export NO_GO=true
export DIR=$DOTFILES_PATH 

curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
python /tmp/get-pip.py

$DIR/common/configure_fresh_system
ln -vfs $DIR/windows_cygwin/.minttyrc $HOME/
ln -vfs $DIR/.gitconfig.cygwin $HOME/.gitconfig
ln -vfs $DIR/.vimrc.cygwin $HOME/.vimrc

