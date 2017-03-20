#!/bin/bash

set -e

if [[ -z $NOUPGRADE ]]; then
    sudo dnf -y upgrade 
fi

sudo dnf -y --best --allowerasing install tmux atop zsh thunderbird thunderbird-enigmail thunderbird-lightning firefox aria2 gajim lm_sensors freecad python3-pip qt5-qtbase-devel qt5-qtwebkit-devel meld whois curl pv nodejs npm terminator gsmartcontrol python-pip mercurial python3-devel libxslt-devel libjpeg-turbo-devel conky conky-manager redshift redshift-gtk cmake gtk2-devel intltool gparted wine solaar glances the_silver_searcher dkms kernel-devel gimp transmission-gtk git xz util-linux-user powertop dnf-automatic kdiff3 yum-utils util-linux-user ncurses-devel zeal qt5-linguist qtkeychain-qt5-devel archivemount keepass splix gutenprint-cups cups-bjnp golang redhat-rpm-config docker pcsc-lite-devel pcsc-tools pcsc-lite yubico-piv-tool yubikey-personalization-gui xloadimage yp-tools closure-compiler optipng jpegoptim grub2 grub2-efi dracut dracut-tools

sudo dnf -y groupinstall "C Development Tools and Libraries"
sudo dnf -y groupinstall "Development Tools"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo cp -v /etc/dnf/automatic.conf /etc/dnf/automatic.conf.bak
sudo cp -v $DIR/etc/dnf/automatic.conf /etc/dnf/automatic.conf
sudo cp -v $DIR/etc/ld.so.conf.d/nextcloud.conf /etc/ld.so.conf.d/nextcloud.conf
sudo cp -v $DIR/etc/sysctl.d/90_swapiness.conf /etc/sysctl.d/
sudo cp -v $DIR/etc/sysctl.d/91_inotify_limit.conf /etc/sysctl.d/
sudo ldconfig

set +e
sudo diff /etc/dnf/automatic.conf.bak /etc/dnf/automatic.conf
set -e

 # SSD TRIM
sudo cp -v /etc/crypttab /etc/crypttab.bak
sudo sed -i 's/none.*$/none luks,discard/g' /etc/crypttab
echo "crypttab:"
set +e
sudo cat /etc/crypttab
sudo diff /etc/crypttab.bak /etc/crypttab
set -e
echo "generating grub config..."
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
echo "generating initramfs..."
sudo dracut -f

if [[ -z $NO_SYSTEMCTL ]]; then
    sudo systemctl enable dnf-automatic.timer
    sudo systemctl start  dnf-automatic.timer
    sudo systemctl enable docker
    sudo systemctl restart docker
    sudo systemctl enable fstrim.timer
    sudo systemctl restart fstrim.timer
    sudo systemctl list-timers
fi

# docker
if [[ -z $USER ]]; then
    USER=`whoami`
fi

getent group docker || sudo groupadd docker
sudo usermod -aG docker $USER

# vscode
mkdir -p ~/Downloads
cd ~/Downloads
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf -y install --best --allowerasing code

if [ "$(id -u)" != "0" ]; then
    code --install-extension cssho.vscode-svgviewer 
    code --install-extension donjayamanne.python
    code --install-extension saviorisdead.RustyCode
    code --install-extension seanmcbreen.Spell
    code --install-extension searKing.preview-vscode
    code --install-extension vscodevim.vim
    code --install-extension webfreak.debug
fi

# dotnet
sudo dnf -y copr enable nmilosev/dotnet-sig
sudo dnf -y install dotnetcore

# vim
if [[ -z $NO_COMPILE_VIM ]]; then
    VIM_BUILD_DIR=`realpath "$DIR/../../"`
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

DIR="$DIR/../"
DIR="$DIR" $DIR/common/configure_fresh_system.sh

