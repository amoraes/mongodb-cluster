IMAGE=amoraes/mongodb-cluster:4.2.19
docker build . -t $IMAGE
docker push $IMAGE