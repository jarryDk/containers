#!/bin/bash

gotoProjectRoot(){
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    echo "Change dir to $SCRIPT_DIR"
    cd $SCRIPT_DIR
}

gotoGrantParent(){
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    PARENT_DIR="$( dirname "$SCRIPT_DIR" )"
    GRANTPARENT_DIR="$( dirname "$PARENT_DIR" )"

    echo "Change dir to $GRANTPARENT_DIR"
    cd $GRANTPARENT_DIR
}

rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
           [-_.~a-zA-Z0-9] ) o="${c}" ;;
           * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"    # You can either set a return variable (FASTER)
    REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

gerForgeMinecraft(){

    FORGE_MINECRAFT_FORGE_VERSION=1.19.2-43.1.47
    FORGE_MINECRAFT_FORGE_NAME=forge-$FORGE_MINECRAFT_FORGE_VERSION-installer.jar
    FORGE_MINECRAFT_FORGE_FOLDER="build/minecraft/forge"
    export FORGE_MINECRAFT_FORGE_FOLDER_INSTALLED="build/minecraft/forge/$FORGE_MINECRAFT_FORGE_VERSION"
    FORGE_MINECRAFT_FORGE_ARCHIVE_PATH=$FORGE_MINECRAFT_FORGE_FOLDER/$FORGE_MINECRAFT_FORGE_NAME
    FORGE_MINECRAFT_FORGE_URL=https://maven.minecraftforge.net/net/minecraftforge/forge/$FORGE_MINECRAFT_FORGE_VERSION/$FORGE_MINECRAFT_FORGE_NAME

    if [ ! -d $FORGE_MINECRAFT_FORGE_FOLDER ]; then
        mkdir -p $FORGE_MINECRAFT_FORGE_FOLDER
    fi

    if [ ! -f $FORGE_MINECRAFT_FORGE_ARCHIVE_PATH ]; then
        wget -c $FORGE_MINECRAFT_FORGE_URL -P $FORGE_MINECRAFT_FORGE_FOLDER
    fi

    if [ ! -d $FORGE_MINECRAFT_FORGE_FOLDER_INSTALLED ]; then
        mkdir -p $FORGE_MINECRAFT_FORGE_FOLDER_INSTALLED
        # Install Mincraft Forge
        java -jar $FORGE_MINECRAFT_FORGE_ARCHIVE_PATH \
            --installServer=$FORGE_MINECRAFT_FORGE_FOLDER_INSTALLED
    fi

    echo ">>>"
    echo "FORGE_MINECRAFT_FORGE_VERSION : $FORGE_MINECRAFT_FORGE_VERSION"
    echo "<<<"

}

getOpenJdk(){

    ## Get OpenJdk from java.net

    case $OPEN_JDK_VERSION in
        17 | 17.0.2)
            OPEN_JDK_VERSION=17.0.2
            OPEN_JDK_VERSION_ID_PATH=dfd4a8d0985749f896bed50d7138ee7f/8
        ;;

        16)
            OPEN_JDK_VERSION=16
            OPEN_JDK_VERSION_ID_PATH=7863447f0ab643c585b9bdebf67c69db/36
        ;;

        15 | 15.0.2)
            OPEN_JDK_VERSION=15.0.2
            OPEN_JDK_VERSION_ID_PATH=0d1cfde4252546c6931946de8db48ee2/7
        ;;

        *)
            OPEN_JDK_VERSION=17.0.2
            OPEN_JDK_VERSION_ID_PATH=dfd4a8d0985749f896bed50d7138ee7f/8
        ;;
    esac

    OPEN_JDK_BASE_URL="https://download.java.net/java/GA/jdk"$OPEN_JDK_VERSION"/$OPEN_JDK_VERSION_ID_PATH/GPL"
    OPEN_JDK_ARCHIVE_NAME="openjdk-"$OPEN_JDK_VERSION"_linux-x64_bin.tar.gz"
    OPEN_JDK_TAR_SHA254="openjdk-"$OPEN_JDK_VERSION"_linux-x64_bin.tar.gz.sha256"

    OPEN_JDK_FINAL_FOLDER="build/openjdk/jdk-$OPEN_JDK_VERSION"
    OPEN_JDK_BASE_URL="$OPEN_JDK_BASE_URL/$OPEN_JDK_ARCHIVE_NAME"
    OPEN_JDK_ARCHIVE_PATH="build/openjdk/$OPEN_JDK_ARCHIVE_NAME"

    echo ">>>"
    echo "OPEN_JDK_BASE_URL : $OPEN_JDK_BASE_URL"
    echo "OPEN_JDK_ARCHIVE_NAME : $OPEN_JDK_ARCHIVE_NAME"
    echo "OPEN_JDK_ARCHIVE_PATH : $OPEN_JDK_ARCHIVE_PATH"
    echo "OPEN_JDK_FINAL_FOLDER : $OPEN_JDK_FINAL_FOLDER"
    echo "<<<"

    if [ ! -d "build/openjdk" ]; then
        mkdir -p "build/openjdk"
    fi

    if [ ! -f $OPEN_JDK_ARCHIVE_PATH ]; then
        wget -c $OPEN_JDK_BASE_URL -P build/
    fi

    if [ ! -f "build/$OPEN_JDK_TAR_SHA254" ]; then
        wget -c "$OPEN_JDK_BASE_URL/$OPEN_JDK_TAR_SHA254" -P build/
    fi

    if [ ! -d "build/openjdk/jdk-$OPEN_JDK_VERSION" ]; then
        tar -xvf "build/$OPEN_JDK_ARCHIVE_NAME" -C build/openjdk/
    fi

    JDK_FOLDER="jdk-$OPEN_JDK_VERSION"
    JDK_BUILD_FOLDER="$OPEN_JDK_FINAL_FOLDER"
}

getOpenJdkFromAdoptium(){

    echo "PWD : $PWD"

    ## Get OpenJdk from Adoptium

    VERSION_JAVA_EIGHT="jdk8u352-b08"
    VERSION_JAVA_EIGHT_ADOPTIUM_TAG=$VERSION_JAVA_EIGHT
    VERSION_JAVA_EIGHT_ADOPTIUM_ARCHIVE_NAME="OpenJDK8U-jdk_x64_linux_hotspot_8u352b08.tar.gz"

    VERSION_JAVA_ELEVEN="jdk-11.0.17+8"
    VERSION_JAVA_ELEVEN_ADOPTIUM_TAG=$( eval "rawurlencode $VERSION_JAVA_ELEVEN")
    VERSION_JAVA_ELEVEN_ADOPTIUM_ARCHIVE_NAME="OpenJDK11U-jdk_x64_linux_hotspot_11.0.17_8.tar.gz"

    VERSION_JAVA_SEVENTEEN="jdk-17.0.5+8"
    VERSION_JAVA_SEVENTEEN_ADOPTIUM_TAG=$( eval "rawurlencode $VERSION_JAVA_SEVENTEEN")
    VERSION_JAVA_SEVENTEEN_ADOPTIUM_ARCHIVE_NAME="OpenJDK17U-jdk_x64_linux_hotspot_17.0.5_8.tar.gz"

    VERSION_JAVA_EIGHTEEN="jdk-18.0.2.1+1"
    VERSION_JAVA_EIGHTEEN_ADOPTIUM_TAG=$( eval "rawurlencode $VERSION_JAVA_EIGHTEEN")
    VERSION_JAVA_EIGHTEEN_ADOPTIUM_ARCHIVE_NAME="OpenJDK18U-jdk_x64_linux_hotspot_18.0.2.1_1.tar.gz"

    VERSION_JAVA_NINETEEN="jdk-19.0.1+10"
    VERSION_JAVA_NINETEEN_ADOPTIUM_TAG=$( eval "rawurlencode $VERSION_JAVA_NINETEEN")
    VERSION_JAVA_NINETEEN_ADOPTIUM_ARCHIVE_NAME="OpenJDK19U-jdk_x64_linux_hotspot_19.0.1_10.tar.gz"

    case $OPEN_JDK_VERSION in
        19)
        # https://github.com/adoptium/temurin19-binaries
        ADOPTIUM_TOP_VERSION=19
        ADOPTIUM_TAG_VERSION=$VERSION_JAVA_NINETEEN_ADOPTIUM_TAG
        ADOPTIUM_FOLDER=$VERSION_JAVA_NINETEEN
        ADOPTIUM_ARCHIVE_NAME=$VERSION_JAVA_NINETEEN_ADOPTIUM_ARCHIVE_NAME
        ;;

        18)
        # https://github.com/adoptium/temurin18-binaries
        ADOPTIUM_TOP_VERSION=18
        ADOPTIUM_TAG_VERSION=$VERSION_JAVA_EIGHTEEN_ADOPTIUM_TAG
        ADOPTIUM_FOLDER=$VERSION_JAVA_EIGHTEEN
        ADOPTIUM_ARCHIVE_NAME=$VERSION_JAVA_EIGHTEEN_ADOPTIUM_ARCHIVE_NAME
        ;;

        17)
        # https://github.com/adoptium/temurin17-binaries
        ADOPTIUM_TOP_VERSION=17
        ADOPTIUM_TAG_VERSION=$VERSION_JAVA_SEVENTEEN_ADOPTIUM_TAG
        ADOPTIUM_FOLDER=$VERSION_JAVA_SEVENTEEN
        ADOPTIUM_ARCHIVE_NAME=$VERSION_JAVA_SEVENTEEN_ADOPTIUM_ARCHIVE_NAME
        ;;

        11)
        # https://github.com/adoptium/temurin11-binaries
        ADOPTIUM_TOP_VERSION=11
        ADOPTIUM_TAG_VERSION=$VERSION_JAVA_ELEVEN_ADOPTIUM_TAG
        ADOPTIUM_FOLDER=$VERSION_JAVA_ELEVEN
        ADOPTIUM_ARCHIVE_NAME=$VERSION_JAVA_ELEVEN_ADOPTIUM_ARCHIVE_NAME
        ;;

        8)
        # https://github.com/adoptium/temurin8-binaries
        ADOPTIUM_TOP_VERSION=8
        ADOPTIUM_TAG_VERSION=$VERSION_JAVA_EIGHT_ADOPTIUM_TAG
        ADOPTIUM_FOLDER=$VERSION_JAVA_EIGHT
        ADOPTIUM_ARCHIVE_NAME=$VERSION_JAVA_EIGHT_ADOPTIUM_ARCHIVE_NAME
        ;;

        *)
        ADOPTIUM_TOP_VERSION=17
        ADOPTIUM_TAG_VERSION=$VERSION_JAVA_SEVENTEEN_ADOPTIUM_TAG
        ADOPTIUM_FOLDER=$VERSION_JAVA_SEVENTEEN
        ADOPTIUM_ARCHIVE_NAME=$VERSION_JAVA_SEVENTEEN_ADOPTIUM_ARCHIVE_NAME
        ;;
    esac

    ADOPTIOM_BASE_URL="https://github.com/adoptium/temurin"$ADOPTIUM_TOP_VERSION"-binaries/releases/download/$ADOPTIUM_TAG_VERSION/$ADOPTIUM_ARCHIVE_NAME"

    ADOPTIUM_ARCHIVE_PATH="build/$ADOPTIUM_ARCHIVE_NAME"
    ADOPTIOM_FINAL_FOLDER="build/openjdk-adoptium/$ADOPTIUM_FOLDER"

    echo ">>>"
    echo "ADOPTIOM_BASE_URL : $ADOPTIOM_BASE_URL"
    echo "ADOPTIUM_ARCHIVE_NAME : $ADOPTIUM_ARCHIVE_NAME"
    echo "ADOPTIUM_ARCHIVE_PATH : $ADOPTIUM_ARCHIVE_PATH"
    echo "ADOPTIOM_FINAL_FOLDER : $ADOPTIOM_FINAL_FOLDER"
    echo "<<<"

    if [ ! -f "$ADOPTIUM_ARCHIVE_PATH" ]; then
        wget -c $ADOPTIOM_BASE_URL -P build
    fi

    if [ ! -d "build/openjdk-adoptium" ]; then
        mkdir -p "build/openjdk-adoptium"
    fi

    if [ ! -d $ADOPTIOM_FINAL_FOLDER ]; then
        tar -xvf $ADOPTIUM_ARCHIVE_PATH  -C "build/openjdk-adoptium"
    fi

    JDK_FOLDER="$ADOPTIUM_FOLDER"
    JDK_BUILD_FOLDER="$ADOPTIOM_FINAL_FOLDER"

}

getWildfly(){

    ## Get Wildfly

    case $WILDFLY_VERSION in

        27.0.0.Beta1)
            WILDFLY_VERSION=27.0.0.Beta1
        ;;
        26.1.2.Final)
            WILDFLY_VERSION=26.1.2.Final
        ;;
        23.0.2.Final)
            WILDFLY_VERSION=23.0.2.Final
        ;;
        23.0.0.Final)
            WILDFLY_VERSION=23.0.0.Final
        ;;
        22.0.1.Final)
            WILDFLY_VERSION=22.0.1.Final
        ;;
        *)
            WILDFLY_VERSION=26.1.2.Final
        ;;
    esac


    WILDFLY_FILENAME=wildfly-$WILDFLY_VERSION
    WILDFLY_ARCHIVE_NAME=$WILDFLY_FILENAME.tar.gz
    WILDFLY_ARCHIVE_PATH="build/$WILDFLY_FILENAME.tar.gz"
    WILDFLY_DOWNLOAD_ADDRESS=https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/$WILDFLY_ARCHIVE_NAME

    if [ ! -f $WILDFLY_ARCHIVE_PATH ]; then
        wget -c "$WILDFLY_DOWNLOAD_ADDRESS" -P build/
    fi

    if [ ! -d "build/wildfly/wildfly-$WILDFLY_VERSION" ]; then
        mkdir -p "build/wildfly/wildfly-$WILDFLY_VERSION"
        tar -xvf $WILDFLY_ARCHIVE_PATH -C "build/wildfly"
    fi

}


getKafka(){

    ## Get Kafka

    if [ ! -n $SCALA_VERSION ]; then
        SCALA_VERSION=2.13
    fi
    if [ ! -n $KAFKA_VERSION ]; then
        KAFKA_VERSION=3.3.1
    fi

    KAFKA_FILENAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
    KAFKA_BASE_URL="https://archive.apache.org/dist/kafka/$KAFKA_VERSION"

    url=$(curl --stderr /dev/null "https://www.apache.org/dyn/closer.cgi?path=/kafka/${KAFKA_VERSION}/${FILENAME}&as_json=1" | jq -r '"\(.preferred)\(.path_info)"')

    echo ">>>"
    echo "KAFKA_FILENAME : $KAFKA_FILENAME"
    echo "KAFKA_BASE_URL : $KAFKA_BASE_URL"
    echo "URL : $url"
    echo "<<<"

    # Test to see if the suggested mirror has this version
    if [[ ! $(curl -f -s -r 0-1 "${url}") ]]; then
        echo "Mirror does not have desired version, downloading direct from Apache"
        url="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${FILENAME}"
    fi

    if [ ! -f "build/$KAFKA_FILENAME" ]; then
        wget -c $url$KAFKA_FILENAME -P build/
    else
        echo "No need to download - we already have the file - $PWD/build/$KAFKA_FILENAME" 
    fi

    if [ ! -d "build/kafka" ]; then
        mkdir -p "build/kafka"
    fi

    if [ ! -d "build/kafka/kafka_${SCALA_VERSION}-${KAFKA_VERSION}" ]; then
        tar -xvf "build/$KAFKA_FILENAME" -C build/kafka/
    fi

}