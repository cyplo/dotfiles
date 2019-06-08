#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo dnf -y groupinstall "C Development Tools and Libraries"
sudo dnf -y groupinstall "Development Tools"

sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y copr enable jdoss/wireguard

if [[ -z $NOUPGRADE ]]; then
    sudo dnf -y groupupdate core
    sudo dnf -y upgrade --best --allowerasing
fi

sudo dnf -y --best --allowerasing install tmux atop zsh firefox aria2 gajim lm_sensors freecad python3-pip qt5-qtbase-devel qt5-qtwebkit-devel whois curl pv gsmartcontrol python-pip mercurial python3-devel libxslt-devel libjpeg-turbo-devel cmake gtk2-devel intltool gparted glances dkms kernel-devel gimp git xz util-linux-user dnf-automatic kdiff3 yum-utils util-linux-user ncurses-devel qt5-linguist qtkeychain-qt5-devel archivemount keepass splix gutenprint-cups cups-bjnp golang redhat-rpm-config pcsc-lite-devel pcsc-tools pcsc-lite yubico-piv-tool yubikey-personalization-gui xloadimage yp-tools closure-compiler optipng jpegoptim grub2 grub2-efi dracut dracut-tools openssl-devel fail2ban syncthing ansible gnome-tweaks xclip wget wireguard-dkms wireguard-tools lldb python-lldb kdbg zlib-devel libuuid-devel libattr-devel libblkid-devel libselinux-devel libudev-devel parted lsscsi ksh openssl-devel elfutils-libelf-devel libtirpc-devel kernel-devel ffmpeg-libs dnf-plugins-core restic duply docker steam clang llvm-devel clang-devel libsodium-devel chromium vim tlp tlp-rdw lua lua-devel luarocks

sudo cp -v /etc/dnf/automatic.conf /etc/dnf/automatic.conf.bak
sudo cp -v $DIR/etc/dnf/automatic.conf /etc/dnf/automatic.conf
sudo cp -v $DIR/etc/sysctl.d/90_swapiness.conf /etc/sysctl.d/
sudo cp -v $DIR/etc/sysctl.d/91_inotify_limit.conf /etc/sysctl.d/
sudo cp -v $DIR/etc/fail2ban/jail.d/01-sshd.conf /etc/fail2ban/jail.d/
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

mkdir -p "$HOME/.config/systemd/"
rm -frv "$HOME/.config/systemd/user"

DIR=`realpath "$DIR/../"`
ln -vfs "$DIR/.config/systemd/user" "$HOME/.config/systemd/"

if [[ -z $NO_SYSTEMCTL ]]; then
    sudo systemctl enable docker
    sudo systemctl restart docker
    sudo systemctl enable fail2ban
    sudo systemctl restart fail2ban
    sudo systemctl enable dnf-automatic-install.timer
    sudo systemctl restart dnf-automatic-install.timer
    sudo systemctl enable fstrim.timer
    sudo systemctl restart fstrim.timer
    sudo systemctl enable tlp
    sudo systemctl restart tlp
    sudo systemctl enable tlp-sleep
    sudo systemctl restart tlp-sleep
    sudo systemctl mask systemd-rfkill.socket
    sudo systemctl enable --now syncthing@cyryl.service
    systemctl --user daemon-reload
    systemctl --user enable restic-backup.timer
    systemctl --user enable restic-backup.service
    systemctl --user list-timers
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

DIR="$DIR" "$DIR/common/up.sh"
