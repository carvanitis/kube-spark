#!/bin/bash

set -e

SPARK_BUILD_VER=2.4.5
REPO_NAME=$1

# Build docker image.
docker build -t apache-spark-pyspark-$SPARK_BUILD_VER -f ./pyspark.Dockerfile .

# Push to docker repository.
docker tag apache-spark-pyspark-$SPARK_BUILD_VER $REPO_NAME/apache-spark-pyspark:$SPARK_BUILD_VER
docker push $REPO_NAME/apache-spark-pyspark:$SPARK_BUILD_VER
