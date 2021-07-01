#!/bin/bash

echo "---------------------------"
echo "- KAFKA_ZOOKEEPER_CONNECT : $KAFKA_ZOOKEEPER_CONNECT"
echo "---------------------------"

if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    echo "ERROR: missing mandatory config: KAFKA_ZOOKEEPER_CONNECT"
    exit 1
fi

/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties --override zookeeper.connect=$KAFKA_ZOOKEEPER_CONNECT