#!/bin/bash

## Get Widlfly 22.0.1.Final 
WILDFLY_VERSION=22.0.1.Final
source "getWildfly.sh"

#########################################################################
#
# Work on image
#

container1=$(buildah from "${1:-jarry-fedora-openjdk:15.0.2}")

## Get all updates 
buildah run "$container1" -- dnf update -y

echo "Add Wildfly to the images"
buildah copy "$container1" build/wildfly/wildfly-$WILDFLY_VERSION /opt/wildfly

## Run our server and expose the port
buildah config --cmd "/opt/wildfly/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0" "$container1"
buildah config --port 8080 "$container1"
buildah config --port 8443 "$container1"
buildah config --port 9990 "$container1"

# ENTRYPOINT ${WILDFLY_HOME}

echo "Commit images"
buildah commit "$container1" ${2:-jarry-fedora-wildfly:22.0.1.Final}