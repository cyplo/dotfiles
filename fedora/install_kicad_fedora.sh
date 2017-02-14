#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set +e
sudo dnf -y remove kicad
set -e

sudo dnf -y groupinstall "C Development Tools and Libraries" 
sudo dnf -y install bzr bzrtools cmake GLC_lib-devel glew-devel cairo-devel bzip2-devel wxGTK3-devel wxGTK-devel openssl-devel doxygen patch glm-devel
$DIR/../common/install_kicad_from_sources

