#!/bin/bash

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

## Install jdk17
echo "Install jdk17"
												
buildah copy "$container1" build/openjdk-17/jdk-17 /opt/java/jdk-17

buildah config --env JAVA_HOME=/opt/java/jdk-17 "$container1"
buildah config --env PATH=/opt/java/jdk-17/bin:$PATH "$container1"

buildah commit "$container1" ${2:-jarry-jdk:17}