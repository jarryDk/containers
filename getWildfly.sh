#!/bin/bash

## Get Wildfly

case $OPEN_JDK_VERSION in
    23.0.0.Final)
        WILDFLY_VERSION=23.0.0.Final
    ;;

    22.0.1.Final)        
        WILDFLY_VERSION=22.0.1.Final
    ;;

    *)
        WILDFLY_VERSION=22.0.1.Final
    ;;
esac

WILDFLY_TAR_GZ=wildfly-$WILDFLY_VERSION.tar.gz
WILDFLY_SHA1=wildfly-$WILDFLY_VERSION.tar.gz.sha1

WILDFLY_DOWNLOAD_TAR_GZ_URI="https://download.jboss.org/wildfly/$WILDFLY_VERSION/$WILDFLY_TAR_GZ"
WILDFLY_DOWNLOAD_SHA1_URI="https://download.jboss.org/wildfly/$WILDFLY_VERSION/$WILDFLY_SHA1"

if [ ! -f "build/WILDFLY_TAR_GZ" ]; then
    wget -c "$WILDFLY_DOWNLOAD_TAR_GZ_URI" -P build/
fi

if [ ! -f "build/$WILDFLY_SHA1" ]; then
    wget -c "$WILDFLY_DOWNLOAD_SHA1_URI" -P build/
fi

if [ ! -d "build/wildfly/wildfly-$WILDFLY_VERSION" ]; then
	mkdir -p "build/wildfly/wildfly-$WILDFLY_VERSION"
    tar -xvf "build/$WILDFLY_TAR_GZ" -C "build/wildfly"
fi