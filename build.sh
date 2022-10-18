IMAGE=amoraes/mongodb-cluster:4.0
docker build . -t $IMAGE --build-arg DB_VERSION=4.0
docker push $IMAGE

IMAGE=amoraes/mongodb-cluster:4.2
docker build . -t $IMAGE --build-arg DB_VERSION=4.2
docker push $IMAGE

IMAGE=amoraes/mongodb-cluster:4.4
docker build . -t $IMAGE --build-arg DB_VERSION=4.4
docker push $IMAGE

IMAGE=amoraes/mongodb-cluster:5.0
docker build . -t $IMAGE --build-arg DB_VERSION=5.0
docker push $IMAGE

IMAGE=amoraes/mongodb-cluster:6.0
docker build . -t $IMAGE --build-arg DB_VERSION=6.0
docker push $IMAGE