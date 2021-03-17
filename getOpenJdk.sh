#!/bin/bash

## Get OpenJdk

case $OPEN_JDK_VERSION in
    16)
        OPEN_JDK_VERSION=16
        OPEN_JDK_VERSION_ID_PATH=7863447f0ab643c585b9bdebf67c69db/36
    ;;

    15.0.2)
        OPEN_JDK_VERSION=15.0.2
        OPEN_JDK_VERSION_ID_PATH=0d1cfde4252546c6931946de8db48ee2/7
    ;;

    *)
        OPEN_JDK_VERSION=15.0.2
        OPEN_JDK_VERSION_ID_PATH=0d1cfde4252546c6931946de8db48ee2/7
    ;;
esac


OPEN_JDK_BASE_URL="https://download.java.net/java/GA/jdk"$OPEN_JDK_VERSION"/$OPEN_JDK_VERSION_ID_PATH/GPL"
OPEN_JDK_TAR_GZ="openjdk-"$OPEN_JDK_VERSION"_linux-x64_bin.tar.gz"
OPEN_JDK_TAR_SHA254="openjdk-"$OPEN_JDK_VERSION"_linux-x64_bin.tar.gz.sha256"

if [ ! -f "build/$OPEN_JDK_TAR_GZ" ]; then
    wget -c "$OPEN_JDK_BASE_URL/$OPEN_JDK_TAR_GZ" -P build/
fi

if [ ! -f "build/$OPEN_JDK_TAR_SHA254" ]; then
    wget -c "$OPEN_JDK_BASE_URL/$OPEN_JDK_TAR_SHA254" -P build/
fi

if [ ! -d "build/openjdk" ]; then
	mkdir -p "build/openjdk"    
fi

if [ ! -d "build/openjdk/jdk-$OPEN_JDK_VERSION" ]; then	
    tar -xvf "build/$OPEN_JDK_TAR_GZ" -C build/openjdk/
fi