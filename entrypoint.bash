#!/bin/bash
# start the config server
mongod --config /etc/mongo/config1.conf &
# wait config server to start
while true; do
  RES=$(cat /var/log/mongodb/mongod-conf1.log | grep "waiting for connections on port")
  if [ "$RES" != "" ]; then
    echo "Config server started."
    break
  fi
  sleep 1
done
# initialise config replica set
mongo --port 27018 /scripts/initiate-config-replica-set.js

# start all replicas
mongod --config /etc/mongo/replica1.conf &
mongod --config /etc/mongo/replica2.conf &
mongod --config /etc/mongo/replica3.conf &

# wait replica servers to start
while true; do
  RES1=$(cat /var/log/mongodb/mongod-replica1.log | grep "waiting for connections on port")
  RES2=$(cat /var/log/mongodb/mongod-replica2.log | grep "waiting for connections on port")
  RES3=$(cat /var/log/mongodb/mongod-replica3.log | grep "waiting for connections on port")
  if [[ "$RES1" != "" && "$RES2" != "" && "$RES3" != "" ]]; then
    echo "Replica servers started."
    break
  fi
  sleep 1
done
mongo --port 27101 /scripts/initiate-replica-set1.js
mongo --port 27102 /scripts/initiate-replica-set2.js
mongo --port 27103 /scripts/initiate-replica-set3.js

# start the mongos (router)
mongos --config /etc/mongo/mongos.conf &
# wait config server to start
while true; do
  RES=$(cat /var/log/mongodb/mongos.log | grep "waiting for connections on port")
  if [ "$RES" != "" ]; then
    echo "Mongos started."
    break
  fi
  sleep 1
done
# initialise config replica set
mongo --port 27017 /scripts/enable-sharding.js
# start the HTTP server with the healthcheck
echo "Mongo cluster started successfully.";

while true; do sleep 30; done;