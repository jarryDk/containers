#!/bin/bash

if [ "X$EULA" == "Xtrue" ]; then
    echo "eula=true" > /opt/minecraft/forge/eula.txt
else
    echo "eula=false" > /opt/minecraft/forge/eula.txt
fi

cd /opt/minecraft/forge
./run.sh