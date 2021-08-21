FROM alpine:latest

LABEL maintainer="Christophe Kyvrakidis <christophe@kyvrakidis.com>"

# Install packages and python dependencies
# Install dev dependencies
# Download source code and install it
# Cleanup directories
# hadolint ignore=DL3018
RUN apk -U upgrade && apk --no-cache add \
    bash \
    python \
    libstdc++ \
    libpcap \
 && apk --update add --virtual build-dependencies \
    git \
    build-base \
    py-pip \
    libpcap-dev \
    python-dev \
 && pip install --disable-pip-version-check pcapy==0.11.3 \
 && git clone https://github.com/stamparm/maltrail.git /opt/maltrail \
 && apk del build-dependencies \
 && rm -fr /root/.cache

# There is no CMD in this file because this image will be used by maltrail-sensor and maltrail-server as base image
