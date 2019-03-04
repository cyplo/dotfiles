FROM fedora:29

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

# rust
RUN curl -sSf https://sh.rustup.rs > /tmp/blastoff.sh
RUN chmod a+x /tmp/blastoff.sh
RUN /tmp/blastoff.sh -y
RUN rm -f /tmp/blastoff.sh

RUN /root/.cargo/bin/rustup update
RUN /root/.cargo/bin/rustup install stable
RUN /root/.cargo/bin/rustup install nightly
RUN /root/.cargo/bin/rustup default stable

RUN /root/.cargo/bin/rustup component add rls --toolchain stable
RUN /root/.cargo/bin/rustup component add clippy --toolchain stable
RUN /root/.cargo/bin/rustup component add rustfmt --toolchain stable
RUN /root/.cargo/bin/rustup component add rust-analysis --toolchain stable
RUN /root/.cargo/bin/rustup component add rust-src --toolchain stable

RUN /root/.cargo/bin/cargo install cargo-update rustsym ripgrep fd-find genpass
RUN /root/.cargo/bin/cargo install-update -a

# vim
RUN mkdir -p /root/dev/
RUN git clone https://github.com/vim/vim.git --recursive /root/dev/vim
RUN cd /root/dev/vim && ./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp \
    --enable-python3interp=yes \
    --enable-luainterp \
    --enable-gui=no \
    --enable-cscope
RUN cd /root/dev/vim && make -j`nproc`
RUN cd /root/dev/vim && make install

# ruby
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash
RUN bash -c "source /etc/profile.d/rvm.sh && rvm install ruby --disable-binary"

# basic packages
RUN dnf -y --best --allowerasing install tmux atop zsh aria2 lm_sensors python3-pip whois curl pv terminator gsmartcontrol python-pip mercurial cmake glances dkms git xz util-linux-user dnf-automatic yum-utils util-linux-user archivemount  redhat-rpm-config grub2 grub2-efi dracut dracut-tools fail2ban syncthing wget wireguard-dkms wireguard-tools parted lsscsi ksh dnf-plugins-core restic duply

# printing
RUN dnf -y --best --allowerasing install splix gutenprint-cups cups-bjnp

# gui tools
RUN dnf -y --best --allowerasing install firefox gajim freecad gparted glances gimp kdiff3 zeal qt5-linguist keepass yubico-piv-tool yubikey-personalization-gui xloadimage gnome-tweaks xclip kdbg

# development
RUN dnf -y --best --allowerasing install mercurial cmake intltool dkms git xz dnf-automatic golang redhat-rpm-config pcsc-tools pcsc-lite xloadimage yp-tools closure-compiler optipng jpegoptim ansible lldb python-lldb

# devel versions of packages
RUN dnf -y --best --allowerasing install qt5-qtbase-devel qt5-qtwebkit-devel python3-devel libxslt-devel libjpeg-turbo-devel gtk2-devel kernel-devel qtkeychain-qt5-devel pcsc-lite-devel openssl-devel zlib-devel libuuid-devel libattr-devel libblkid-devel libselinux-devel libudev-devel openssl-devel elfutils-libelf-devel libtirpc-devel ffmpeg-libs dnf-plugins-core
