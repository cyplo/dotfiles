#!/bin/bash
sudo yum groupinstall "C Development Tools and Libraries" 
sudo yum install bzr bzrtools cmake GLC_lib-devel glew-devel cairo-devel bzip2-devel wxGTK3-devel openssl-devel doxygen patch

bzr launchpad-login "saipeloan" 
bzr whoami "Cyryl Plotnicki-Chudyk <bzr@cyplo.net>" 

mkdir -p ~/build/kicad
cd ~/build/kicad

echo "add the following pubkey to launchpad:"
cat ~/.ssh/id_rsa.pub
echo "press [enter] when the key is added"
read
echo "checking out sources..."

bzr checkout lp:kicad kicad.bzr
cd kicad.bzr
mkdir build
cd build
cmake -DKICAD_STABLE_VERSION=ON ../
make clean
make -j8
sudo make install

# install component libraries
cd ~/build/kicad
bzr checkout lp:~kicad-product-committers/kicad/library kicad-library.bzr
cd kicad-library.bzr
mkdir build 
cd build/ 
cmake ../ 
sudo make install

