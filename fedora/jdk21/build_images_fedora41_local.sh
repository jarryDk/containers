#!/bin/bash

./build_images_fedora41.sh fedora:41 localhost/jarrydk/fedora-41-adoptium-openjdk:21

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    localhost/jarrydk/fedora-41-adoptium-openjdk:21 \
    java -version