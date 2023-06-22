#!/bin/bash

./build_images.sh fedora-minimal:38 jarrydk/fedora-minimal-adoptium-openjdk:17

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    jarrydk/fedora-minimal-adoptium-openjdk:17 \
    java -version