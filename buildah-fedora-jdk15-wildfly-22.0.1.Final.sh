#!/bin/bash

source "getWildfly-22.0.1.Final.sh"

#########################################################################
#
# Work on image
#

container1=$(buildah from "${1:-jarry-jdk:15}")

## Get all updates 
buildah run "$container1" -- dnf update -y

echo "Add Wildfly to the images"
buildah copy "$container1" build/wildfly/wildfly-22.0.1.Final /opt/wildfly

## Run our server and expose the port
buildah config --cmd "/opt/wildfly/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0" "$container1"
buildah config --port 8080 "$container1"
buildah config --port 8443 "$container1"
buildah config --port 9990 "$container1"

ENTRYPOINT ${WILDFLY_HOME}

echo "Commit images"
buildah commit "$container1" ${2:-jarry-wildfly:22.0.1.Final}