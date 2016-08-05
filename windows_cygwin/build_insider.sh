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
export NOVIM=true
export DIR=$DOTFILES_PATH 

$DIR/common/configure_fresh_system

