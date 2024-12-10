#!/bin/bash

OPEN_JDK_VERSION=21

source ../../toolbox.sh

# Goto root of project
gotoProjectRoot

## Get OpenJDK from Adoptium
getOpenJdkFromAdoptium

#########################################################################
#
# Work on images
#

# container1=$(buildah from "${1:-docker.io/jarrydk/fedora-updates:41}")
container1=$(buildah from "${1:-localhost/jarrydk/fedora-minimal-updates:41}")

## Get all updates
echo "Get all updates"
buildah run "$container1" -- microdnf update -y

## Clean up after update
echo "Clean up after update"
buildah run "$container1" -- microdnf clean all -y

## Install OpenJdk
echo "Install OpenJdk - $JDK_FOLDER"

buildah copy "$container1" $JDK_BUILD_FOLDER /opt/java/$JDK_FOLDER

buildah config --env JAVA_HOME=/opt/java/$JDK_FOLDER "$container1"
buildah config --env PATH=/opt/java/$JDK_FOLDER/bin:$PATH "$container1"

buildah config --label org.label-schema.name="fedora-minimal-41-openjdk" "$container1"
buildah config --label org.label-schema.description="Fedora Minimal 41 - OpenJdk - ${OPEN_JDK_VERSION}" "$container1"
buildah config --label org.label-schema.build-date="${build_date}" "$container1"
buildah config --label org.label-schema.vcs-url="https://github.com/jarrydk/containers" "$container1"
buildah config --label org.label-schema.version="${OPEN_JDK_VERSION}" "$container1"
buildah config --label org.label-schema.schema-version="1.0" "$container1"
buildah config --label maintainer="jarrydk" "$container1"
buildah config --label license="Apache License Version 2.0" "$container1"

# buildah commit "$container1" ${2:-docker.io/jarrydk/fedora-minimal-41-adoptium-openjdk:21}
buildah commit "$container1" ${2:-localhost/jarrydk/fedora-minimal-41-adoptium-openjdk:21}

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    localhost/jarrydk/fedora-minimal-41-adoptium-openjdk:21 \
    java -version