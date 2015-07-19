[![Build Status](https://travis-ci.org/cyplo/dotfiles.svg?branch=master)](https://travis-ci.org/cyplo/dotfiles)

My common dotfiles for Linux, Mac and Cygwin

e.g. my vim, terminal and font configs.

install:

    sudo apt-get update
    sudo apt-get install git # or yum install git
     
    ssh-keygen -b 8192
    cat ~/.ssh/id_rsa.pub
    #add the above key to github
    mkdir ~/dev
    cd ~/dev
    git clone git@github.com:cyplo/dotfiles.git
    cd dotfiles
    ./ubuntu/configure_fresh_system
    # or /debian/.. or /fedora/..

GNOME extensions list:
* Clipboard Indicator
* Hibernate Status Button
* Pixel Saver

TODO:
* automate adding backports to debian-based distros
* automate adding gnome extensions
