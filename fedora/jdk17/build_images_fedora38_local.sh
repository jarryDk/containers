#!/bin/bash

./build_images_fedora38.sh fedora:38 jarrydk/fedora-38-adoptium-openjdk:17

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    jarrydk/fedora-38-adoptium-openjdk:17 \
    java -version