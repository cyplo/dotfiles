FROM fedora:24

RUN dnf -y install sudo
RUN sudo dnf -y upgrade --best --allowerasing
RUN sudo dnf -y --best --allowerasing install tmux atop zsh thunderbird thunderbird-enigmail thunderbird-lightning firefox aria2 gajim lm_sensors freecad python3-pip qt5-qtbase-devel qt5-qtwebkit-devel meld whois curl pv nodejs npm terminator gsmartcontrol python-pip mercurial python3-devel libxslt-devel libjpeg-turbo-devel conky conky-manager redshift redshift-gtk cmake gtk2-devel intltool gparted wine solaar glances the_silver_searcher dkms kernel-devel gimp transmission-gtk git xz util-linux-user powertop dnf-automatic kdiff3 yum-utils util-linux-user ncurses-devel zeal

RUN sudo dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-24.noarch.rpm
RUN sudo dnf -y install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-24.noarch.rpm
RUN sudo dnf -y --best --allowerasing install vlc splix gutenprint-cups cups-bjnp mono-devel keepass mplayer golang ncurses-compat-libs kicad retext
RUN sudo dnf -y groupinstall "C Development Tools and Libraries"
RUN sudo dnf -y groupinstall "Development Tools"

RUN git clone https://github.com/vim/vim.git /tmp/vim
RUN cd /tmp/vim && ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-python3interp=yes \
            --enable-luainterp \
            --enable-gui=no \
            --enable-cscope && make -j2 && sudo make install
