#!/bin/bash

FORGE_MINECRAFT_FORGE_VERSION=1.19.2-43.1.47

source ../../toolbox.sh

# Goto root of project
gotoProjectRoot

## Get Minecraft from forge
gerForgeMinecraft

#########################################################################
#
# Work on images
#

# container1=$(buildah from "${1:-docker.io/jarrydk/fedora-minimal-adoptium-openjdk:19}")
container1=$(buildah from "${1:-jarrydk/fedora-minimal-adoptium-openjdk:19}")

## Get all updates
echo "Get all updates"
buildah run "$container1" -- microdnf update -y

## Clean up after update
echo "Clean up after update"
buildah run "$container1" -- microdnf clean all -y

## Install Minecraft - Forge
echo "Install Minecraft Forge"

buildah copy "$container1" $FORGE_MINECRAFT_FORGE_FOLDER_INSTALLED /opt/minecraft/forge

buildah config --label org.label-schema.name="fedora-minimal-minecraft-forge" "$container1"
buildah config --label org.label-schema.description="Fedora Minimal - Minecraft - Forge - ${FORGE_MINECRAFT_FORGE_VERSION}" "$container1"
buildah config --label org.label-schema.build-date="${build_date}" "$container1"
buildah config --label org.label-schema.vcs-url="https://github.com/jarrydk/containers" "$container1"
buildah config --label org.label-schema.version="${FORGE_MINECRAFT_FORGE_VERSION}" "$container1"
buildah config --label org.label-schema.schema-version="1.0" "$container1"
buildah config --label maintainer="jarrydk" "$container1"
buildah config --label license="Apache License Version 2.0" "$container1"


echo "Add start_minecraft.sh to the container"
buildah copy "$container1" minecraft/forge/start_minecraft.sh /opt/minecraft/forge/start_minecraft.sh

## Run our server and expose the port
buildah config --cmd "/opt/minecraft/forge/start_minecraft.sh"  "$container1"
buildah config --port 25565  "$container1"

# buildah commit "$container1" ${2:-docker.io/jarrydk/fedora-minimal-minecraft-forge:1.19.2}
buildah commit "$container1" ${2:-jarrydk/fedora-minimal-minecraft-forge:1.19.2}
