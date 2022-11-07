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

podman build -f minecraft/forge/Containerfile -t ${2:-jarrydk/fedora-minimal-minecraft-forge:1.19.2} .
