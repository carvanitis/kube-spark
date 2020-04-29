#!/bin/bash

set -e

SPARK_BUILD_VER=2.4.5
REPO_NAME=uprush

# Build docker image.
docker build --build-arg SPARK_VERSION=$SPARK_BUILD_VER \
	-t apache-spark-$SPARK_BUILD_VER -f ./Dockerfile-spark .

# Push to docker repository.
docker tag apache-spark-$SPARK_BUILD_VER $REPO_NAME/apache-spark:$SPARK_BUILD_VER
docker push $REPO_NAME/apache-spark:$SPARK_BUILD_VER
