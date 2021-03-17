#!/bin/bash

## Get jdk 16
OPEN_JDK_VERSION=16
source "getOpenJdk.sh"

if [ ! -d "build/openjdk/jdk-$OPEN_JDK_VERSION" ] ; then
    echo "You need to download OpenJDK $OPEN_JDK_VERSION before you can use it."
    exit 2;
fi

#########################################################################
#
# Work on images
#

container1=$(buildah from "${1:-fedora:33}")

## Get all updates
echo "Get all updates"
buildah run "$container1" -- dnf update -y

## Clean up after update
echo "Clean up after update"
buildah run "$container1" -- dnf clean all -y

## Install OpenJdk
echo "Install OpenJdk - $OPEN_JDK_VERSION"
												
buildah copy "$container1" build/openjdk/jdk-$OPEN_JDK_VERSION /opt/java/jdk-$OPEN_JDK_VERSION

buildah config --env JAVA_HOME=/opt/java/jdk-$OPEN_JDK_VERSION "$container1"
buildah config --env PATH=/opt/java/jdk-$OPEN_JDK_VERSION/bin:$PATH "$container1"

buildah commit "$container1" ${2:-jarry-fedora-openjdk:16}