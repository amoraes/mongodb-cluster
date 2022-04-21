FROM ubuntu:bionic
ARG DB_VERSION
RUN /bin/sh -c "apt-get update"
RUN /bin/sh -c "apt-get install -y wget gnupg"
RUN /bin/sh -c "wget -qO - https://www.mongodb.org/static/pgp/server-$DB_VERSION.asc | apt-key add -"
RUN /bin/sh -c "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/$DB_VERSION multiverse\" | tee /etc/apt/sources.list.d/mongodb-org-$DB_VERSION.list"
RUN /bin/sh -c "apt-get update"
RUN /bin/sh -c "apt-get install -y mongodb-org"
# create data dirs
RUN /bin/sh -c "mkdir -p /var/lib/mongodb-conf1"
RUN /bin/sh -c "mkdir -p /var/lib/mongodb-replica1"
RUN /bin/sh -c "mkdir -p /var/lib/mongodb-replica2"
RUN /bin/sh -c "mkdir -p /var/lib/mongodb-replica3"
RUN /bin/sh -c "echo $DB_VERSION > /mongodb-version"
# copy configs
COPY config/config1.conf /etc/mongo/config1.conf
COPY config/replica1.conf /etc/mongo/replica1.conf
COPY config/replica2.conf /etc/mongo/replica2.conf
COPY config/replica3.conf /etc/mongo/replica3.conf
COPY config/mongos.conf /etc/mongo/mongos.conf
# copy scripts
COPY scripts/initiate-config-replica-set.js /scripts/initiate-config-replica-set.js
COPY scripts/initiate-replica-set1.js /scripts/initiate-replica-set1.js
COPY scripts/initiate-replica-set2.js /scripts/initiate-replica-set2.js
COPY scripts/initiate-replica-set3.js /scripts/initiate-replica-set3.js
COPY scripts/enable-sharding.js /scripts/enable-sharding.js

COPY entrypoint.bash entrypoint.bash
ENTRYPOINT ["/bin/bash", "entrypoint.bash"]
