#!/bin/bash

./build_images.sh fedora-minimal:37 jarrydk/fedora-minimal-37-adoptium-openjdk:19

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    jarrydk/fedora-minimal-37-adoptium-openjdk:19 \
    java -version