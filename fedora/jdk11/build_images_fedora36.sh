#!/bin/bash

OPEN_JDK_VERSION=11

source ../../toolbox.sh

# Goto root of project
gotoProjectRoot

## Get OpenJDK from Adoptium
getOpenJdkFromAdoptium

#########################################################################
#
# Work on images
#

# container1=$(buildah from "${1:-docker.io/jarrydk/fedora-updates:36}")
container1=$(buildah from "${1:-jarrydk/fedora-updates:36}")

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
buildah config --label org.label-schema.description="Fedora 36 - OpenJdk - ${OPEN_JDK_VERSION}" "$container1"
buildah config --label org.label-schema.build-date="${build_date}" "$container1"
buildah config --label org.label-schema.vcs-url="https://github.com/jarrydk/containers" "$container1"
buildah config --label org.label-schema.version="${OPEN_JDK_VERSION}" "$container1"
buildah config --label org.label-schema.schema-version="1.0" "$container1"
buildah config --label maintainer="jarrydk" "$container1"
buildah config --label license="Apache License Version 2.0" "$container1"

# buildah commit "$container1" ${2:-docker.io/jarrydk/fedora-36-adoptium-openjdk:11}
buildah commit "$container1" ${2:-jarrydk/fedora-36-adoptium-openjdk:11}

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    jarrydk/fedora-adoptium-openjdk:11 \
    java -version