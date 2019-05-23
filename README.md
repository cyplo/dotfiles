[![Build Status](https://travis-ci.org/cyplo/dotfiles.svg?branch=master)](https://travis-ci.org/cyplo/dotfiles)
[![Build status](https://ci.appveyor.com/api/projects/status/s6i314lyti4o1ny1/branch/master?svg=true)](https://ci.appveyor.com/project/cyplo/dotfiles/branch/master)
[![pipeline status](https://gitlab.com/cyplo/dotfiles/badges/master/pipeline.svg)](https://gitlab.com/cyplo/dotfiles/commits/master)

My common dotfiles for Linux, Mac and Cygwin

e.g. my vim, terminal and font configs.

install:

    sudo apt-get update
    sudo apt-get install git # or yum install git

    ssh-keygen -t ed25519
    cat .ssh/id_ed25519.pub 
    #add the above key to github
    mkdir ~/dev
    cd ~/dev
    git clone git@github.com:cyplo/dotfiles.git
    cd dotfiles
    ./fedora/up.sh
    # or ./ubuntu/up.sh

GNOME extensions list:
* Clipboard Indicator
* Hibernate Status Button
* Pixel Saver

TODO:
* automate adding gnome extensions
