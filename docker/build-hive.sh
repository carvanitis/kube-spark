#!/bin/bash

set -e

HIVE_BUILD_VER=3.1.2
REPO_NAME=uprush

# Build docker image.
docker build --build-arg HIVE_VERSION=$HIVE_BUILD_VER \
	-t apache-hive-$HIVE_BUILD_VER -f ./Dockerfile-hive .

# Push to docker repository.
docker tag apache-hive-$HIVE_BUILD_VER $REPO_NAME/apache-hive:$HIVE_BUILD_VER
docker push $REPO_NAME/apache-hive:$HIVE_BUILD_VER
