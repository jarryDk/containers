#!/bin/bash

OPEN_JDK_VERSION=17

source ../../toolbox.sh

# Goto root of project
gotoProjectRoot

## Get OpenJDK from Adoptium
getOpenJdkFromAdoptium

if [ ! -d $JDK_BUILD_FOLDER ] ; then
    echo "You need to download OpenJDK $OPEN_JDK_VERSION before you can use it."
    exit 2;
fi

#########################################################################
#
# Work on images
#

container1=$(buildah from "${1:-centos:latest}")

## Get all updates
echo "Get all updates"
buildah run "$container1" -- dnf update -y

## Clean up after update
echo "Clean up after update"
buildah run "$container1" -- dnf clean all -y

## Install OpenJdk
echo "Install OpenJdk - $JDK_FOLDER"

buildah copy "$container1" $JDK_BUILD_FOLDER /opt/java/$JDK_FOLDER

buildah config --env JAVA_HOME=/opt/java/$JDK_FOLDER "$container1"
buildah config --env PATH=/opt/java/$JDK_FOLDER/bin:$PATH "$container1"

buildah config --label org.label-schema.name="fedora-openjdk" "$container1"
buildah config --label org.label-schema.description="Fedora - OpenJdk - ${OPEN_JDK_VERSION}" "$container1"
buildah config --label org.label-schema.build-date="${build_date}" "$container1"
buildah config --label org.label-schema.vcs-url="https://github.com/jarrydk/containers" "$container1"
buildah config --label org.label-schema.version="${OPEN_JDK_VERSION}" "$container1"
buildah config --label org.label-schema.schema-version="1.0" "$container1"
buildah config --label maintainer="jarrydk" "$container1"
buildah config --label license="Apache License Version 2.0" "$container1"

# buildah commit "$container1" ${2:-docker.io/jarrydk/centos-adoptium-openjdk:17}
buildah commit "$container1" ${2:-jarrydk/centos-adoptium-openjdk:17}

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    jarrydk/centos-adoptium-openjdk:17 \
    java -version