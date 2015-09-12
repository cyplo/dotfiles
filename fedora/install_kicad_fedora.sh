#!/bin/bash
sudo dnf groupinstall "C Development Tools and Libraries" 
sudo dnf install bzr bzrtools cmake GLC_lib-devel glew-devel cairo-devel bzip2-devel wxGTK3-devel wxGTK-devel openssl-devel doxygen patch
../common/install_kicad_from_sources


