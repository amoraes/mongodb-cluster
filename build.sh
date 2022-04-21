IMAGE=amoraes/mongodb-cluster:4.0
docker build . -t $IMAGE --build-arg DB_VERSION=4.0
docker push $IMAGE

IMAGE=amoraes/mongodb-cluster:4.2
docker build . -t $IMAGE --build-arg DB_VERSION=4.2
docker push $IMAGE

