#!/bin/bash

set -e

DOTFILES_PATH="$HOME/dev/dotfiles"
mkdir -pv $HOME/dev/

if [[ ! -d $DOTFILES_PATH ]]; then
    git clone "$OUTER_CLONE" "$DOTFILES_PATH"
fi

cd "$DOTFILES_PATH"
git checkout $branch

git remote set-url origin https://github.com/cyplo/dotfiles.git
git pull

git remote set-url origin git@github.com:cyplo/dotfiles.git
# might fail on CI where there are no secret keys
set +e
git pull
set -e

export NOSUDO=true
export DONT_CHANGE_SHELL=true
export NORUST=true
export NO_GO=true
export DIR=$DOTFILES_PATH 
export NOYCM=true

curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
python /tmp/get-pip.py

# expose all the binaries fetched during the outer build
export PATH="$OUTER_CLONE:$PATH"

$DIR/common/configure_fresh_system
ln -vfs $DIR/windows_cygwin/.minttyrc $HOME/
ln -vfs $DIR/.gitconfig.cygwin $HOME/.gitconfig
ln -vfs $DIR/.vimrc.cygwin $HOME/.vimrc

# reinstall plugins with the new vimrc
echo "Reinstalling Vim plugins with the correct plugin list"
echo "\n" | vim +PluginInstall +qa

