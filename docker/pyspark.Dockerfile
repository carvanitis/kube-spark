ARG REPO
FROM ${REPO}/apache-spark:2.4.5

USER root

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    python3 \
    python3-dev \
    python3-pip \
    python3-wheel

# Clear
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s $(which python3) /usr/local/bin/python

RUN python3 -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools

RUN python3 -m pip --no-cache-dir install \
    wheel \
    pypandoc \
    pyspark==2.4.5
