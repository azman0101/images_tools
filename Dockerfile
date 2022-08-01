
FROM debian:bullseye as build-env

RUN apt update && apt-get install -y curl build-essential bind9utils libbind-dev libkrb5-dev libssl-dev libcap-dev libxml2-dev libjson-c-dev libgeoip-dev python3

FROM debian:bullseye-slim

RUN apt update && apt install -qqy dnsutils curl vim telnet python3 wget python3-pip \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /google-cloud-sdk/bin:$PATH
ARG CLOUD_SDK_VERSION=395.0.0
RUN curl -LO "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz" && \
    tar xzf "google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz" && \
    rm "google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz" && \
    ln -s /lib /lib64 && \
    rm -rf /google-cloud-sdk/.install/.backup && \
    gcloud version && \
    ls -lah /google-cloud-sdk/bin

RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image

RUN pip install rsa
COPY ./scripts /
COPY README.md /

ENTRYPOINT [ "/bin/bash" ]
