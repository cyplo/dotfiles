FROM fedora:29

ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8

RUN dnf -y upgrade --best --allowerasing
RUN dnf -y --best --allowerasing install tmux atop zsh firefox aria2 gajim lm_sensors freecad python3-pip qt5-qtbase-devel qt5-qtwebkit-devel meld whois curl pv terminator gsmartcontrol python-pip mercurial python3-devel libxslt-devel libjpeg-turbo-devel conky conky-manager cmake gtk2-devel intltool gparted wine solaar glances the_silver_searcher dkms kernel-devel gimp transmission-gtk git xz util-linux-user powertop dnf-automatic kdiff3 yum-utils util-linux-user ncurses-devel zeal qt5-linguist qtkeychain-qt5-devel archivemount keepass splix gutenprint-cups cups-bjnp golang redhat-rpm-config pcsc-lite-devel pcsc-tools pcsc-lite yubico-piv-tool yubikey-personalization-gui xloadimage yp-tools closure-compiler optipng jpegoptim grub2 grub2-efi dracut dracut-tools openssl-devel fail2ban syncthing ansible gnome-tweaks xclip

RUN dnf -y install docker

RUN dnf -y groupinstall "C Development Tools and Libraries"
RUN dnf -y groupinstall "Development Tools"

RUN dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN dnf -y groupupdate core

RUN dnf -y install ffmpeg-libs

RUN mkdir -p /root/dev/
# vim
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

RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash
RUN bash -c "source /etc/profile.d/rvm.sh && rvm install ruby --disable-binary"

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
