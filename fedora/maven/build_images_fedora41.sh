#!/bin/bash

source ../../toolbox.sh

# Goto root of project
gotoProjectRoot

OPEN_JDK_VERSION=21
MAVEN_VERSION=3.9.9

## Get OpenJDK from Adoptium
getOpenJdkFromAdoptium

## Get Maven
getMaven

#########################################################################
#
# Work on images
#

container1=$(buildah from "${1:-localhost/jarrydk/fedora-updates:41}")

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

## Install Maven
echo "Install Maven - $MAVEN_FOLDER"

buildah copy "$container1" $MAVEN_BUILD_FOLDER /opt/maven/$MAVEN_FOLDER

buildah config --env M2_HOME=/opt/maven/$MAVEN_FOLDER "$container1"
buildah config --env PATH=/opt/java/$JDK_FOLDER/bin:/opt/maven/$MAVEN_FOLDER/bin:$PATH "$container1"

buildah config --label org.label-schema.name="fedora-41-openjdk" "$container1"
buildah config --label org.label-schema.description="Fedora 41 - OpenJdk ${OPEN_JDK_VERSION} - Maven ${MAVEN_VERSION}" "$container1"
buildah config --label org.label-schema.build-date="${build_date}" "$container1"
buildah config --label org.label-schema.vcs-url="https://github.com/jarrydk/containers" "$container1"
buildah config --label org.label-schema.version="${OPEN_JDK_VERSION}" "$container1"
buildah config --label org.label-schema.schema-version="1.0" "$container1"
buildah config --label maintainer="jarrydk" "$container1"
buildah config --label license="Apache License Version 2.0" "$container1"

buildah commit "$container1" ${2:-localhost/jarrydk/fedora-41-adoptium:openjdk-21-maven}

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    localhost/jarrydk/fedora-41-adoptium:openjdk-21-maven\
    mvn -version