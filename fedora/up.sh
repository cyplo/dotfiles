#!/bin/bash

set -e

sudo dnf -y groupinstall "C Development Tools and Libraries"
sudo dnf -y groupinstall "Development Tools"

sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y copr enable jdoss/wireguard

if [[ -z $NOUPGRADE ]]; then
    sudo dnf -y groupupdate core
    sudo dnf -y upgrade --best --allowerasing
fi

sudo dnf -y --best --allowerasing install tmux atop zsh firefox aria2 gajim lm_sensors freecad python3-pip qt5-qtbase-devel qt5-qtwebkit-devel whois curl pv terminator gsmartcontrol python-pip mercurial python3-devel libxslt-devel libjpeg-turbo-devel cmake gtk2-devel intltool gparted glances dkms kernel-devel gimp git xz util-linux-user dnf-automatic kdiff3 yum-utils util-linux-user ncurses-devel zeal qt5-linguist qtkeychain-qt5-devel archivemount keepass splix gutenprint-cups cups-bjnp golang redhat-rpm-config pcsc-lite-devel pcsc-tools pcsc-lite yubico-piv-tool yubikey-personalization-gui xloadimage yp-tools closure-compiler optipng jpegoptim grub2 grub2-efi dracut dracut-tools openssl-devel fail2ban syncthing ansible gnome-tweaks xclip wget wireguard-dkms wireguard-tools lldb python-lldb kdbg zlib-devel libuuid-devel libattr-devel libblkid-devel libselinux-devel libudev-devel parted lsscsi ksh openssl-devel elfutils-libelf-devel libtirpc-devel kernel-devel ffmpeg-libs dnf-plugins-core

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine

sudo dnf config-manager -y --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io

sudo cp -v /etc/dnf/automatic.conf /etc/dnf/automatic.conf.bak
sudo cp -v $HERE/etc/dnf/automatic.conf /etc/dnf/automatic.conf
sudo cp -v $HERE/etc/sysctl.d/90_swapiness.conf /etc/sysctl.d/
sudo cp -v $HERE/etc/sysctl.d/91_inotify_limit.conf /etc/sysctl.d/
sudo cp -v $HERE/etc/fail2ban/jail.d/01-sshd.conf /etc/fail2ban/jail.d/
sudo ldconfig

set +e
sudo diff /etc/dnf/automatic.conf.bak /etc/dnf/automatic.conf
set -e

 # SSD TRIM
if [[ -f /etc/crypttab ]]; then
    sudo cp -v /etc/crypttab /etc/crypttab.bak
    sudo sed -i 's/none.*$/none luks,discard/g' /etc/crypttab
    echo "crypttab:"
    set +e
    sudo cat /etc/crypttab
    sudo diff /etc/crypttab.bak /etc/crypttab
    set -e
else
    echo "No crypttab..."
fi

if sudo test -f /boot/efi/EFI/fedora/grub.cfg; then
    echo "generating grub config..."
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    echo "generating initramfs..."
    sudo dracut -f
else
    echo "No grub.cfg ..."
fi

if [[ -z $NO_SYSTEMCTL ]]; then
    sudo systemctl enable docker
    sudo systemctl restart docker
    sudo systemctl enable fail2ban
    sudo systemctl restart fail2ban
    sudo systemctl enable dnf-automatic-install.timer
    sudo systemctl restart dnf-automatic-install.timer
    sudo systemctl enable fstrim.timer
    sudo systemctl restart fstrim.timer
    sudo systemctl enable --now syncthing@cyryl.service
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
    code --install-extension vscodevim.vim
fi

HERE="$HERE/../"
HERE="$HERE" $HERE/common/configure_fresh_system.sh

