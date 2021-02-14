#!/bin/bash

## Get jdk 15.0.2

OPEN_JDK_BASE_URL="https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL"
OPEN_JDK_TAR_GZ="openjdk-15.0.2_linux-x64_bin.tar.gz"
OPEN_JDK_TAR_SHA254="openjdk-15.0.2_linux-x64_bin.tar.gz.sha256"

if [ ! -f "build/$OPEN_JDK_TAR_GZ" ]; then
    wget -c "$OPEN_JDK_BASE_URL/$OPEN_JDK_TAR_GZ" -P build/
fi

if [ ! -f "build/$OPEN_JDK_TAR_SHA254" ]; then
    wget -c "$OPEN_JDK_BASE_URL/$OPEN_JDK_TAR_SHA254" -P build/
fi

if [ ! -d "build/openjdk-15" ]; then
	mkdir -p "build/openjdk-15"
    tar -xvf $OPEN_JDK_TAR_GZ -C openjdk-15/
fi