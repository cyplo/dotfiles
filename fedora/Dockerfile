FROM fedora:30

ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8

RUN dnf -y groupinstall "C Development Tools and Libraries"
RUN dnf -y groupinstall "Development Tools"

RUN dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf -y copr enable jdoss/wireguard

RUN dnf -y groupupdate core
RUN dnf -y upgrade --best --allowerasing

RUN dnf -y groupinstall gnome

# requirements for early packages and crates
RUN dnf -y --best --allowerasing install openssl-devel ncurses-devel

# basic packages
RUN dnf -y --best --allowerasing install tmux atop zsh aria2 lm_sensors python3-pip whois curl pv terminator gsmartcontrol python-pip mercurial cmake glances dkms git xz util-linux-user dnf-automatic yum-utils util-linux-user archivemount  redhat-rpm-config grub2 grub2-efi dracut dracut-tools fail2ban syncthing wget wireguard-dkms wireguard-tools parted lsscsi ksh dnf-plugins-core restic duply

# printing
RUN dnf -y --best --allowerasing install splix gutenprint-cups cups-bjnp

# gui tools
RUN dnf -y --best --allowerasing install firefox gajim freecad gparted glances gimp kdiff3 qt5-linguist keepass yubico-piv-tool yubikey-personalization-gui xloadimage gnome-tweaks xclip kdbg

# development
RUN dnf -y --best --allowerasing install mercurial cmake intltool dkms git xz dnf-automatic golang redhat-rpm-config pcsc-tools pcsc-lite xloadimage yp-tools closure-compiler optipng jpegoptim ansible lldb python-lldb

# devel versions of packages
RUN dnf -y --best --allowerasing install qt5-qtbase-devel qt5-qtwebkit-devel python3-devel libxslt-devel libjpeg-turbo-devel gtk2-devel kernel-devel qtkeychain-qt5-devel pcsc-lite-devel openssl-devel zlib-devel libuuid-devel libattr-devel libblkid-devel libselinux-devel libudev-devel openssl-devel elfutils-libelf-devel libtirpc-devel ffmpeg-libs dnf-plugins-core
