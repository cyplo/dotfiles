#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
export PATH="/usr/local/bin:$PATH"

set +e
brew unlink gnupg
brew unlink gnupg2
brew uninstall gnupg
brew uninstall gnupg2
brew unlink dirmngr
brew uninstall dirmngr
brew unlink gpg-agent
brew uninstall gpg-agent
set -e

brew update
brew upgrade
brew cask list | xargs brew cask install --force

brew install --force gnupg2
brew install reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste

brew install aria2
brew install \
  autojump \
  bash \
  mobile-shell \
  the_silver_searcher \
  tmux \
  tree \
  watch \
  zsh

brew install \
  coreutils \
  curl \
  dos2unix \
  findutils \
  gawk \
  gnu-sed \
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
  wget \
  fontconfig \
  syncthing

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
  go \
  optipng \
  jpegoptim

brew cask install gimp
brew cask install iterm2
brew cask install docker
brew cask install appcode
brew cask install adium
brew cask install kdiff3

reattach-to-user-namespace brew services restart syncthing

if ! fgrep /usr/local/bin/zsh /etc/shells; then
  sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi

brew linkapps
brew cleanup
brew prune
set +e
mv "$HOME/.cargo/bin/cargo-install-update-config" "$HOME/.cargo/bin/cargo-install-update-cfg" 
set -e
brew doctor
set +e
mv "$HOME/.cargo/bin/cargo-install-update-cfg" "$HOME/.cargo/bin/cargo-install-update-config" 
set -e

echo "Configuring NVRAM"
sudo nvram SystemAudioVolume=%80
defaults write com.google.Keystone.Agent checkInterval 4233600

DIR="$DIR/../"
DIR=`realpath "$DIR"`
if [[ -z $CONTINUOUS_INTEGRATION ]]; then
    echo "Invoking common configuration scripts"
    DIR="$DIR" $DIR/common/configure_fresh_system.sh
fi
ln -vfs "$DIR/.gitconfig.mac" $HOME/.gitconfig

mkdir -p "$HOME/Library/Application Support/Code/User/"
ln -vfs "$DIR/.config/Code/User/settings.json.mac" "$HOME/Library/Application Support/Code/User/settings.json"
