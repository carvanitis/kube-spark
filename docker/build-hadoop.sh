#!/bin/bash

set -e

HADOOP_VER=3.2.1
REPO_NAME=uprush

# Build docker image.
docker build --build-arg HADOOP_VERSION=$HADOOP_VER \
	-t apache-hadoop-$HADOOP_VER -f ./Dockerfile-hadoop .

# Push to docker repository.
docker tag apache-hadoop-$HADOOP_VER $REPO_NAME/apache-hadoop:$HADOOP_VER
docker push $REPO_NAME/apache-hadoop:$HADOOP_VER
