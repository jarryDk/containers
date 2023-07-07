#!/bin/bash

KAFKA_DATA_DIR_DEFAULT='/tmp/zookeeper'
KAFKA_ADMIN_ENABLE_SERVER_DEFAULT='false'
KAFKA_ADMIN_SERVER_PORT_DEFAULT='8080'

echo "-----------------------------------------------------------------------------------"
echo "- KAFKA_DATA_DIR                      : $KAFKA_DATA_DIR"
echo "--- KAFKA_DATA_DIR_DEFAULT            : $KAFKA_DATA_DIR_DEFAULT"
echo "- KAFKA_ADMIN_ENABLE_SERVER           : $KAFKA_ADMIN_ENABLE_SERVER"
echo "--- KAFKA_ADMIN_ENABLE_SERVER_DEFAULT : $KAFKA_ADMIN_ENABLE_SERVER_DEFAULT"
echo "- KAFKA_ADMIN_SERVER_PORT             : $KAFKA_ADMIN_SERVER_PORT"
echo "--- KAFKA_ADMIN_SERVER_PORT_DEFAULT   : $KAFKA_ADMIN_SERVER_PORT_DEFAULT"
echo "-----------------------------------------------------------------------------------"


if [ ! -z "$KAFKA_DATA_DIR" ]; then
    sed -i 's/dataDir/# dataDir/g' zookeeper.properties
    sed -i '17 i dataDir='$KAFKA_DATA_DIR'' /opt/kafka/config/zookeeper.properties
else
    sed -i '17 i # Default value is used for dataDir ('$KAFKA_DATA_DIR_DEFAULT')' /opt/kafka/config/zookeeper.properties
fi

if [ ! -z "$KAFKA_ADMIN_ENABLE_SERVER" ]; then
    sed -i 's/admin.enableServer/# admin.enableServer/g' /opt/kafka/config/zookeeper.properties
    sed -i '25 i admin.enableServer='$KAFKA_ADMIN_ENABLE_SERVER'' /opt/kafka/config/zookeeper.properties
else
    sed -i '25 i # Default value is used for admin.enableServer ('$KAFKA_ADMIN_ENABLE_SERVER_DEFAULT')' /opt/kafka/config/zookeeper.properties
fi

echo "" >> /opt/kafka/config/zookeeper.properties
if [ ! -z "$KAFKA_ADMIN_SERVER_PORT" ]; then
    echo "admin.serverPort=$KAFKA_ADMIN_SERVER_PORT" >> /opt/kafka/config/zookeeper.properties
else
    echo "# Default value is used for admin.serverPort ($KAFKA_ADMIN_SERVER_PORT_DEFAULT)" >> /opt/kafka/config/zookeeper.properties
fi

/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties