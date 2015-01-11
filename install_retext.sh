#!/bin/bash

#ReText
aria2c http://sourceforge.net/projects/pyqt/files/sip/sip-4.16.2/sip-4.16.2.tar.gz -d /tmp
tar -C /tmp -xf /tmp/sip-4.16.2.tar.gz
cd /tmp/sip-4.16.2
python3 configure.py
make
sudo make install
aria2c http://sourceforge.net/projects/pyqt/files/PyQt5/PyQt-5.3.1/PyQt-gpl-5.3.1.tar.gz -d /tmp
tar -C /tmp -xf /tmp/PyQt-gpl-5.3.1.tar.gz
cd /tmp/PyQt-gpl-5.3.1
python3 configure.py --qmake /usr/bin/qmake-qt5
make -j8
sudo make install

sudo pip-python3 install retext
