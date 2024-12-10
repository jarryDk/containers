#!/bin/bash

./build_images.sh fedora-minimal:41 localhost/jarrydk/fedora-minimal-41-adoptium-openjdk:21

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    localhost/jarrydk/fedora-minimal-41-adoptium-openjdk:21 \
    java -version