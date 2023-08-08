#!/bin/bash

KAFKA_LISTENERS_DEFAULT="PLAINTEXT://:9092"
KAFKA_ADVERTISED_LISTENERS_DEFAULT="PLAINTEXT://localhost:9092"
KAFKA_LISTENER_SECURITY_PROTOCAL_MAP_DEFAULT="PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL"
KAFKA_BROKER_ID_DEFAULT="0"
KAFKA_LOG_DIRS_DEFAULT="/tmp/kafka-logs"

echo "-----------------------------------------------------------------------------------"
echo "- KAFKA_ZOOKEEPER_CONNECT                         : $KAFKA_ZOOKEEPER_CONNECT"

echo "- KAFKA_LISTENERS                                 : $KAFKA_LISTENERS"
echo "--- KAFKA_LISTENERS_DEFAULT                       : $KAFKA_LISTENERS_DEFAULT"

echo "- KAFKA_LISTENER_SECURITY_PROTOCAL_MAP            : $KAFKA_LISTENER_SECURITY_PROTOCAL_MAP"
echo "--- KAFKA_LISTENER_SECURITY_PROTOCAL_MAP_DEFAULT  : $KAFKA_LISTENER_SECURITY_PROTOCAL_MAP_DEFAULT"

echo "- KAFKA_INTER_BROKER_LISTENER_NAME                : $KAFKA_INTER_BROKER_LISTENER_NAME"

echo "- KAFKA_SSL_TRUSTSTORE_LOCATION                   : $KAFKA_SSL_TRUSTSTORE_LOCATION"
echo "- KAFKA_SSL_KEYSTORE_LOCATION                     : $KAFKA_SSL_KEYSTORE_LOCATION"
echo "- KAFKA_SSL_CLIENT_AUTH                           : $KAFKA_SSL_CLIENT_AUTH"

echo "- KAFKA_ADVERTISED_LISTENERS                      : $KAFKA_ADVERTISED_LISTENERS"
echo "--- KAFKA_ADVERTISED_LISTENERS_DEFAULT            : $KAFKA_ADVERTISED_LISTENERS"

echo "- KAFKA_BROKER_ID                                 : $KAFKA_BROKER_ID"
echo "--- KAFKA_BROKER_ID_DEFAULT                       : $KAFKA_BROKER_ID_DEFAULT"

echo "- KAFKA_LOG_DIRS                                  : $KAFKA_LOG_DIRS"
echo "--- KAFKA_LOG_DIRS_DEFAULT                        : $KAFKA_LOG_DIRS_DEFAULT"
echo "-----------------------------------------------------------------------------------"

if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    echo "ERROR: missing mandatory config: KAFKA_ZOOKEEPER_CONNECT"
    exit 1
fi

if [[ -z "$KAFKA_LISTENERS" ]]; then
    KAFKA_LISTENERS=$KAFKA_LISTENERS_DEFAULT
fi

# https://www.confluent.io/blog/kafka-listeners-explained/
if [ -z ${KAFKA_ADVERTISED_LISTENERS+x} ]; then
    KAFKA_ADVERTISED_LISTENERS=$KAFKA_ADVERTISED_LISTENERS_DEFAULT
fi

if [[ -z "$KAFKA_LISTENER_SECURITY_PROTOCAL_MAP" ]]; then
    KAFKA_LISTENER_SECURITY_PROTOCAL_MAP=$KAFKA_LISTENER_SECURITY_PROTOCAL_MAP_DEFAULT
fi

# https://kafka.apache.org/35/generated/kafka_config.html#brokerconfigs_inter.broker.listener.name
if [ -z ${KAFKA_INTER_BROKER_LISTENER_NAME+x} ]; then
    INTER_BROKER_LISTENER_NAME=""
else
    INTER_BROKER_LISTENER_NAME="--override inter.broker.listener.name=$KAFKA_INTER_BROKER_LISTENER_NAME"
fi
echo "INTER_BROKER_LISTENER_NAME : $INTER_BROKER_LISTENER_NAME"

# https://kafka.apache.org/31/generated/kafka_config.html#brokerconfigs_ssl.truststore.location
if [ -z ${KAFKA_SSL_TRUSTSTORE_LOCATION+x} ]; then
    SSL_TRUSTSTORE_LOCATION=""
else
    SSL_TRUSTSTORE_LOCATION="--override ssl.truststore.location=$KAFKA_SSL_TRUSTSTORE_LOCATION"
fi
echo "SSL_TRUSTSTORE_LOCATION : $SSL_TRUSTSTORE_LOCATION"

# https://kafka.apache.org/31/generated/kafka_config.html#brokerconfigs_ssl.truststore.password
if [ -z ${KAFKA_SSL_TRUSTSTORE_PASSWORD+x} ]; then
    SSL_TRUSTSTORE_PASSWORD=""
else
    SSL_TRUSTSTORE_PASSWORD="--override ssl.truststore.password=$KAFKA_SSL_TRUSTSTORE_PASSWORD"
fi

# https://kafka.apache.org/31/generated/kafka_config.html#brokerconfigs_ssl.keystore.location
if [ -z ${KAFKA_SSL_KEYSTORE_LOCATION+x} ]; then
    SSL_KEYSTORE_LOCATION=""
else
    SSL_KEYSTORE_LOCATION="--override ssl.keystore.location=$KAFKA_SSL_KEYSTORE_LOCATION"
fi
echo "SSL_KEYSTORE_LOCATION : $SSL_KEYSTORE_LOCATION"

# https://kafka.apache.org/31/generated/kafka_config.html#brokerconfigs_ssl.keystore.password
if [ -z ${KAFKA_SSL_KEYSTORE_PASSWORD+x} ]; then
    SSL_KEYSTORE_PASSWORD=""
else
    SSL_KEYSTORE_PASSWORD="--override ssl.keystore.password=$KAFKA_SSL_KEYSTORE_PASSWORD"
fi

# https://kafka.apache.org/31/generated/kafka_config.html#brokerconfigs_ssl.client.auth
if [ -z ${KAFKA_SSL_CLIENT_AUTH+x} ]; then
    SSL_CLIENT_AUTH=""
else
    SSL_CLIENT_AUTH="--override ssl.client.auth=$KAFKA_SSL_CLIENT_AUTH"
fi
echo "SSL_CLIENT_AUTH : $SSL_CLIENT_AUTH"

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    KAFKA_BROKER_ID=$KAFKA_BROKER_ID_DEFAULT
fi

if [[ -z "$KAFKA_LOG_DIRS" ]]; then
    KAFKA_LOG_DIRS=$KAFKA_LOG_DIRS_DEFAULT
fi

/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties \
    --override zookeeper.connect=$KAFKA_ZOOKEEPER_CONNECT \
    --override listeners=$KAFKA_LISTENERS \
    --override listener.security.protocol.map=$KAFKA_LISTENER_SECURITY_PROTOCAL_MAP \
    $INTER_BROKER_LISTENER_NAME \
    $SSL_TRUSTSTORE_LOCATION $SSL_TRUSTSTORE_PASSWORD \
    $SSL_KEYSTORE_LOCATION $SSL_KEYSTORE_PASSWORD \
    $SSL_CLIENT_AUTH \
    --override advertised.listeners=$KAFKA_ADVERTISED_LISTENERS \
    --override broker.id=$KAFKA_BROKER_ID \
    --override log.dirs=$KAFKA_LOG_DIRS