#!/bin/bash
set -e

if [[ $TRAVIS_OS_NAME == "osx" ]]; then
    export DONT_CHANGE_SHELL=true
    if [[ -d $/.cargo ]]; then
        echo "Cache warmed up, real build proceeding"
        ./macosx/configure_fresh_system.sh
    else
        echo "Pre-warming cache"
        ./ci/mac/warmup.sh
    fi
    exit 0
fi

if [[ -z $DETECTED_OS ]]; then
    echo "cannot detect OS, please set DETECTED_OS manually"
    exit 1
fi

if [[ $DETECTED_OS =~ .*:.* ]]; then
   SYSTEM_NAME=`echo $DETECTED_OS | cut -d':' -f1` 
   SYSTEM_VERSION=`echo $DETECTED_OS | cut -d':' -f2` 
else
    echo "please set DETECTED_OS to system:version"
    exit 1
fi

INSIDER_ROOT_DIR=/root/temp/dotfiles/
CURRENT_DIR=`pwd`

SYSTEM_DIR="$SYSTEM_NAME/"
SYSTEM_VERSION_DIR="$SYSTEM_NAME/$SYSTEM_VERSION/"

if [[ -d "$CURRENT_DIR/$SYSTEM_VERSION_DIR" ]]; then
    DIR=$SYSTEM_VERSION_DIR
else
    DIR=$SYSTEM_DIR
fi

if [[ -z $DOCKER_IMAGE ]]; then
    DOCKER_IMAGE="$DETECTED_OS"
fi

docker run -v $CURRENT_DIR:$INSIDER_ROOT_DIR $DOCKER_IMAGE $INSIDER_ROOT_DIR/$DIR/test_insider

