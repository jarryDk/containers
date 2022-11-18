#!/bin/bash

./build_images_fedora37.sh fedora:37 jarrydk/fedora-37-adoptium-openjdk:17

echo "----------------------------"
echo "------   TESTING  ----------"
echo "----------------------------"
podman run -it --rm=true \
    jarrydk/fedora-37-adoptium-openjdk:17 \
    java -version