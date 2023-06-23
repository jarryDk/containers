#!/bin/bash

echo "---------------------------"
echo "- KAFKA_ZOOKEEPER_CONNECT : $KAFKA_ZOOKEEPER_CONNECT"
echo "- KAFKA_LISTENERS : $KAFKA_LISTENERS"
echo "- KAFKA_ADVERTISED_LISTENERS : $KAFKA_ADVERTISED_LISTENERS"
echo "- KAFKA_BROKER_ID : $KAFKA_BROKER_ID"
echo "---------------------------"

if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    echo "ERROR: missing mandatory config: KAFKA_ZOOKEEPER_CONNECT"
    exit 1
fi

if [[ -z "$KAFKA_LISTENERS" ]]; then
    KAFKA_LISTENERS="PLAINTEXT://:9092"
fi

# https://www.confluent.io/blog/kafka-listeners-explained/
if [[ -z "$KAFKA_ADVERTISED_LISTENERS" ]]; then
    KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://localhost:9092"
fi

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    KAFKA_BROKER_ID="0"
fi

/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties \
    --override zookeeper.connect=$KAFKA_ZOOKEEPER_CONNECT \
    --override listeners=$KAFKA_LISTENERS \
    --override advertised.listeners=$KAFKA_ADVERTISED_LISTENERS \
    --override broker.id=$KAFKA_BROKER_ID