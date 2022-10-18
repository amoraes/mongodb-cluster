#!/bin/bash
# start the config server
mongod --config /etc/mongo/config1.conf &
DB_VERSION=$(cat /mongodb-version)
echo "MongoDB version: $DB_VERSION"

MONGO_SHELL="mongo"
if [[ "$DB_VERSION" == 6* ]]; then
  MONGO_SHELL="mongosh"
fi
echo "Using $MONGO_SHELL command as the Mongo Shell"

function hasStarted() {
  # the messages are slightly different in recent versions
  RES1=$(cat $1 | grep "waiting for connections on port")
  RES2=$(cat $1 | grep "Waiting for connections")
  if [[ "$RES1" != "" || "$RES2" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# wait config server to start
while true; do
  RES=$(hasStarted /var/log/mongodb/mongod-conf1.log)
  if [ "$RES" == "true" ]; then
    echo "Config server started."
    break
  fi
  sleep 1
done
# initialise config replica set
$MONGO_SHELL --port 27018 /scripts/initiate-config-replica-set.js

# start all replicas
mongod --config /etc/mongo/replica1.conf &
mongod --config /etc/mongo/replica2.conf &
mongod --config /etc/mongo/replica3.conf &

# wait replica servers to start
while true; do
  RES1=$(hasStarted /var/log/mongodb/mongod-replica1.log)
  RES2=$(hasStarted /var/log/mongodb/mongod-replica2.log)
  RES3=$(hasStarted /var/log/mongodb/mongod-replica3.log)
  if [[ "$RES1" == "true" && "$RES2" == "true" && "$RES3" == "true" ]]; then
    echo "Replica servers started."
    break
  fi
  sleep 1
done
$MONGO_SHELL --port 27101 /scripts/initiate-replica-set1.js
$MONGO_SHELL --port 27102 /scripts/initiate-replica-set2.js
$MONGO_SHELL --port 27103 /scripts/initiate-replica-set3.js

# start the mongos (router)
mongos --config /etc/mongo/mongos.conf &
# wait config server to start
while true; do
  RES=$(hasStarted /var/log/mongodb/mongos.log)
  if [ "$RES" == "true" ]; then
    echo "Mongos started."
    break
  fi
  sleep 1
done
# initialise config replica set
$MONGO_SHELL --port 27017 /scripts/enable-sharding.js
# start the HTTP server with the healthcheck
echo "Mongo cluster started successfully.";

while true; do sleep 30; done;