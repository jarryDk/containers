#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENT_DIR="$( dirname "$SCRIPT_DIR" )"
GRANTPARENT_DIR="$( dirname "$PARENT_DIR" )"

echo "Change dir to $GRANTPARENT_DIR"
cd $GRANTPARENT_DIR

build_date=`date --utc +%FT%T.%3NZ`

## Get kafka 3.1.0
SCALA_VERSION=2.13
KAFKA_VERSION=3.1.0
KAFKA_FILENAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
source "./getKafka.sh"

echo "$GRANTPARENT_DIR/build/$KAFKA_FILENAME"

if [ ! -d "$GRANTPARENT_DIR/build/kafka/kafka_${SCALA_VERSION}-${KAFKA_VERSION}" ] ; then
    echo "You need to download $KAFKA_FILENAME before you can use it."
    exit 2;
fi

#########################################################################
#
# Work on images
#

# container1=$(buildah from "${1:-fedora:35}")
# container1=$(buildah from "${1:-jarry-fedora-updates:35}")
container1=$(buildah from "${1:-jarry-fedora-openjdk:17}")

## Get all updates
echo "Get all updates"
buildah run "$container1" -- dnf update -y

## Install scala
echo "Install scala"
buildah run "$container1" -- dnf install scala -y

## Clean up after update
echo "Clean up after update"
buildah run "$container1" -- dnf clean all -y

## Install Kafka
echo "Install Kafka - kafka_${SCALA_VERSION}-${KAFKA_VERSION}"
												
buildah copy "$container1" build/kafka/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

buildah copy "$container1" fedora/kafka/start-kafka-jarrydk.sh /opt/kafka/start-kafka-jarrydk.sh

buildah config --env KAFKA_HOME=/opt/kafka "$container1"
buildah config --env PATH=${KAFKA_HOME}/bin:$PATH "$container1"

## Run our server and expose the port
buildah config --cmd "/opt/kafka/start-kafka-jarrydk.sh" "$container1"
buildah config --port 9092 "$container1"

buildah config --label org.label-schema.name="kafka" "$container1"
buildah config --label org.label-schema.description="Apache Kafka" "$container1"
buildah config --label org.label-schema.build-date="${build_date}" "$container1"
buildah config --label org.label-schema.vcs-url="https://github.com/jarrydk/containers" "$container1"
buildah config --label org.label-schema.version="${SCALA_VERSION}_${KAFKA_VERSION}" "$container1"
buildah config --label org.label-schema.schema-version="1.0" "$container1"
buildah config --label maintainer="jarrydk" "$container1" 
buildah config --label license="Apache License Version 2.0" "$container1" 

buildah commit "$container1" ${2:-docker.io/jarrydk/fedora-kafka:3.1}
# buildah commit "$container1" ${2:-jarry-fedora-kafka:3.1}