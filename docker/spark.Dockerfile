ARG REPO
FROM ${REPO}/apache-hadoop:3.2.1

# Variables that define which software versions to install.
ARG SCALA_VER=2.11.12
ARG SPARK_VERSION=2.4.5

# Install 
RUN apt update && apt install -y curl tini libc6 libpam-modules libnss3

# Install fake java6-runtime-headless (scala 2.11 dependency) in order to install Scala
RUN apt install -y --no-install-recommends equivs
COPY java6-runtime-headless.control /tmp
RUN cd /tmp && equivs-build /tmp/java6-runtime-headless.control \
    && dpkg -i java6-runtime-headless_8u242_all.deb \
    && rm java6-runtime-headless.control \
    && rm java6-runtime-headless_8u242_all.deb

# Download and install Scala.
RUN curl -O https://www.scala-lang.org/files/archive/scala-$SCALA_VER.deb \
	&& dpkg -i scala-$SCALA_VER.deb \
	&& rm scala-$SCALA_VER.deb

# Download and install Spark.
ARG PACKAGE=spark-$SPARK_VERSION-bin-without-hadoop
RUN curl https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/$PACKAGE.tgz \
	| tar -xvz -C /opt/ \
	&& ln -s /opt/$PACKAGE /opt/spark

# Retrieve Spark cloud jar
RUN curl -O https://repo.hortonworks.com/content/repositories/releases/org/apache/spark/spark-hadoop-cloud_2.11/2.3.2.3.1.0.6-1/spark-hadoop-cloud_2.11-2.3.2.3.1.0.6-1.jar \
	&& mv spark-hadoop-cloud_2.11-2.3.2.3.1.0.6-1.jar /opt/spark/jars/

# Add 'spark' user so that this cluster is not run as root.
RUN groupadd -g 1080 spark && \
    useradd -r -m -u 1080 -g spark spark && \
    chown -R -L spark /opt/spark && \
    chgrp -R -L spark /opt/spark
USER spark
WORKDIR /home/spark

# Set necessary environment variables. 
ENV SPARK_HOME="/opt/spark"
ENV PATH="/opt/spark/bin:${PATH}"
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /opt/spark/conf/spark-env.sh

COPY entrypoint.sh /opt
ENTRYPOINT ["/opt/entrypoint.sh"]
