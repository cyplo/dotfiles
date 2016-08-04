#!/bin/bash

DOTFILES_PATH="$HOME/dev/dotfiles"
mkdir -pv $HOME/dev/
rm -fr $DOTFILES_PATH

git clone "$OUTER_CLONE" "$DOTFILES_PATH"
cd "$DOTFILES_PATH"
git remote set-url origin git@github.com:cyplo/dotfiles.git
git checkout $branch
export DIR=$DOTFILES_PATH && NOSUDO=true DONT_CHANGE_SHELL=true NORUST=true $DIR/common/configure_fresh_system

