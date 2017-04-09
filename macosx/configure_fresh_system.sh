#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
export PATH="/usr/local/bin:$PATH"

set -e

brew update
brew upgrade

echo "Installing basic console utils"
brew install vim
brew install aria2
brew install \
  autojump \
  bash \
  mobile-shell \
  the_silver_searcher \
  tmux \
  reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste \
  tree \
  watch \
  zsh

echo "Installing networking tools"

brew unlink gnupg2
brew uninstall gnupg2

brew install --force \
  coreutils \
  curl \
  dos2unix \
  findutils \
  gawk \
  gnu-sed \
  gnupg2 \
  gpg-agent \
  htop-osx \
  httpie \
  httping \
  jq \
  moreutils \
  pinentry \
  pinentry-mac \
  socat \
  unrar \
  wget

echo "Installing programmming tools"
brew install \
  carthage \
  cmake \
  elm \
  git \
  haskell-stack \
  heroku \
  mercurial \
  node \
  python \
  python3 \
  ruby \
  sqlite \
  tidy-html5 \
  doxygen \
  go

echo "Installing GUI tools"
brew cask install gimp
brew cask install iterm2
brew cask install docker
brew cask install p4merge
brew cask install appcode
brew cask install kicad

echo "Settings up zsh"
if ! fgrep /usr/local/bin/zsh /etc/shells; then
  sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi

echo "Brew cleanup"
brew linkapps
brew cleanup
brew prune
brew doctor

echo "Configuring NVRAM"
sudo nvram SystemAudioVolume=%80

DIR="$DIR/../"
if [[ -z $CONTINUOUS_INTEGRATION ]]; then
    echo "Invoking common configuration scripts"
    DIR="$DIR" $DIR/common/configure_fresh_system.sh
fi
ln -vfs "$DIR/.gitconfig.mac" ~/.gitconfig

