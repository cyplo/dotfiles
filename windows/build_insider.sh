#!/bin/bash

set +e

chmod ao-rwx ~/.ssh/id_rsa

set -e

DOTFILES_PATH="$HOME/dev/dotfiles"
mkdir -pv $HOME/dev/
ln -vfs "$OUTER_CLONE/.gitconfig.cygwin" $HOME/.gitconfig
if [[ ! -d $DOTFILES_PATH ]]; then
    git clone "$OUTER_CLONE" "$DOTFILES_PATH"
fi

cd "$DOTFILES_PATH"
git remote set-url origin https://github.com/cyplo/dotfiles.git
git fetch -p
git checkout $branch
set +e
git pull
set -e
git remote set-url origin git@github.com:cyplo/dotfiles.git
# might fail on CI where there are no secret keys
set +e
git pull
set -e
unset branch

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

echo "Invoking common configuration script"
$DIR/common/configure_fresh_system.sh

echo "Making symlinks"
ln -vfs $DIR/windows_cygwin/.minttyrc $HOME/
ln -vfs "$DOTFILES_PATH/.gitconfig.cygwin" $HOME/.gitconfig
ln -vfs $DIR/.vimrc.cygwin $HOME/.vimrc

