MongoDB Cluster
--
This project contains a MongoDB cluster (Version 4.0, 4.2, 4.4, 5.0 and 6.0 are available) with the following infrastructure:

* Mongos (port 27017)
* Mongod Config (port 27018)
* Mongod Shard 1 (ReplicaSet rs1) (port 27101)
* Mongod Shard 2 (ReplicaSet rs2) (port 27102)
* Mongod Shard 3 (ReplicaSet rs3) (port 27103)

The images are available at:
amoraes/mongodb-cluster:4.0
amoraes/mongodb-cluster:4.2
amoraes/mongodb-cluster:4.4
amoraes/mongodb-cluster:5.0
amoraes/mongodb-cluster:6.0

After building it, use `docker-compose up --force-recreate` to run.

This can be used for unit tests/integration tests that require to test sharding.

After starting the docker, you can configure the shards by running a script similar to the one below against the Mongos (port 27017).

```javascript
db = db.getSiblingDB('config');
tags = db.tags.find({}).count();
// only runs the first time
if (tags == 0) {
    print('No tags found, creating...')
    sh.enableSharding("test");
    sh.shardCollection("test.Persons", {"countryCode": 1, "_id": 1});
    sh.shardCollection("test.Companies", {"countryCode": 1, "_id": 1});
    db = db.getSiblingDB('test');
    db.Persons.createIndex(
        {countryCode: 1, _id: 1});
    db.Companies.createIndex(
        {countryCode: 1, _id: 1});
    sh.addShardToZone("rs1", "Z1");
    sh.addShardToZone("rs2", "Z2");
    sh.addShardToZone("rs3", "Z3");
    sh.addTagRange(
        "test.Persons",
        {countryCode: "AA"},
        {countryCode: "GG"},
        "Z1"
    );
    sh.addTagRange(
        "test.Persons",
        {countryCode: "HH"},
        {countryCode: "OO"},
        "Z2"
    );
    sh.addTagRange(
        "test.Persons",
        {countryCode: "PP"},
        {countryCode: "ZZ"},
        "Z3"
    );
    sh.addTagRange(
        "test.Companies",
        {countryCode: "AA"},
        {countryCode: "GG"},
        "Z1"
    );
    sh.addTagRange(
        "test.Companies",
        {countryCode: "HH"},
        {countryCode: "OO"},
        "Z2"
    );
    sh.addTagRange(
        "test.Companies",
        {countryCode: "PP"},
        {countryCode: "ZZ"},
        "Z3"
    );
}
```