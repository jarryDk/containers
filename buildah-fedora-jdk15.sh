#!/bin/bash

## Get jdk 15.0.2

source "getJdk-15.0.2.sh"

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

## Install jdk15
echo "Install jdk15"
												
buildah copy "$container1" build/openjdk-15/jdk-15.0.2 /opt/java/jdk-15.0.2

buildah config --env JAVA_HOME=/opt/java/jdk-15.0.2 "$container1"
buildah config --env PATH=/opt/java/jdk-15.0.2/bin:$PATH "$container1"

buildah commit "$container1" ${2:-jarry-jdk:15}