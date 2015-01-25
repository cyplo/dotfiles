#!/bin/bash

BASEDIR="$HOME/RepRap" # edit this is you don't want it installed in your home directory

PRINTRUNDIR="$BASEDIR/Printrun" # Defines where the 'Printrun' directory is located. But of course
                                # you can change this to say: "$HOME/Documents/Create/RepRap/Printrun".

SKEINFORGEDIR="$PRINTRUNDIR/skeinforge" #Defines where the 'skeinforge' directory is located in the
                                # 'Printrun' directory is located.

SKEINFORGEBASEURL="http://fabmetheus.crsndoo.com/files/"
SKEINFORGEFILENAME="50_reprap_python_beanshell.zip"

set -e

sudo yum install git pyserial wxPython tkinter python-pyglet python-psutil

mkdir -p $BASEDIR
cd $BASEDIR # Change directory to the executing users home directory.

echo "Removing existing Printrun directory..." #Script being polite towards the user.
rm -rf $PRINTRUNDIR # Removes the defined Printrun directory and _everything_ that resides
                    # in and beneath its directory tree.

echo "Cloning Printrun..." # Script being polite towards the user.
git clone https://github.com/kliment/Printrun.git # See also: http://help.github.com/linux-set-up-git/

echo "Grabbing skeinforge..." # Script being polite towards the user.
wget -P /tmp $SKEINFORGEBASEURL$SKEINFORGEFILENAME # Uses good ol' wget for downloading skeinforge.

echo "Unzipping skeinforge into Printrun directory..." # Script being polite towards the user.
unzip -d $SKEINFORGEDIR /tmp/$SKEINFORGEFILENAME # unzips the grabbed zip to ones defined skeinforge dir.

echo "Symlinking skeinforge inside Printrun directory..." #Script being polite towards the user.
ln -s $SKEINFORGEDIR/* $PRINTRUNDIR/ # Script makes a symbolic link.

echo "Cleaning up temporary installation files..." #Script being polite towards the user.
rm -rf /tmp/$SKEINFORGEFILENAME # Removes tmp files.

