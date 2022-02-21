#!/bin/bash

## Get Kafka

SCALA_VERSION=2.13
KAFKA_VERSION=3.1.0

KAFKA_FILENAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
KAFKA_BASE_URL="https://archive.apache.org/dist/kafka/$KAFKA_VERSION"

url=$(curl --stderr /dev/null "https://www.apache.org/dyn/closer.cgi?path=/kafka/${KAFKA_VERSION}/${FILENAME}&as_json=1" | jq -r '"\(.preferred)\(.path_info)"')

echo "url : $url"                               
 
# Test to see if the suggested mirror has this version
if [[ ! $(curl -f -s -r 0-1 "${url}") ]]; then
    echo "Mirror does not have desired version, downloading direct from Apache"
    url="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${FILENAME}"
fi

if [ ! -f "build/$KAFKA_FILENAME" ]; then
    wget -c $url$KAFKA_FILENAME -P build/
fi

if [ ! -d "build/kafka" ]; then
	mkdir -p "build/kafka"    
fi

if [ ! -d "build/kafka/kafka_${SCALA_VERSION}-${KAFKA_VERSION}" ]; then	
    tar -xvf "build/$KAFKA_FILENAME" -C build/kafka/
fi