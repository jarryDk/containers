#!/bin/bash

WILDFLY_VERSION=26.1.2.Final

source ../../toolbox.sh

# Goto root of project
gotoProjectRoot

## Get Widlfly
getWildfly

#########################################################################
#
# Work on image
#

container1=$(buildah from "${1:-jarrydk/centos-adoptium-openjdk:17}")

## Get all updates
buildah run "$container1" -- dnf update -y

echo "Add Wildfly to the images"
buildah copy "$container1" build/wildfly/wildfly-$WILDFLY_VERSION /opt/wildfly

## Run our server and expose the port
buildah config --cmd "/opt/wildfly/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0" "$container1"
buildah config --port 8080 "$container1"
buildah config --port 8443 "$container1"
buildah config --port 9990 "$container1"

echo "Commit images"
buildah commit "$container1" ${2:-jarrydk/centos-wildfly:26.1.2.Final}