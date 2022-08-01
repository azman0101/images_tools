
FROM debian:bullseye as build-env

RUN apt update && apt-get install -y curl build-essential bind9utils libbind-dev libkrb5-dev libssl-dev libcap-dev libxml2-dev libjson-c-dev libgeoip-dev

RUN curl ftp://ftp.nominum.com/pub/nominum/dnsperf/2.1.0.0/dnsperf-src-2.1.0.0-1.tar.gz -O \
    && tar xfvz dnsperf-src-2.1.0.0-1.tar.gz \
    && cd dnsperf-src-2.1.0.0-1 \
    && ./configure \
    && make \
    && ls -lah


FROM debian:stretch-slim

RUN apt update && apt install -qqy dnsutils curl vim telnet wget \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts /
COPY README.md /
COPY --from=build-env /dnsperf-src-2.1.0.0-1/dnsperf /usr/local/bin/

RUN chmod +x *.sh /usr/local/bin/dnsperf

ENTRYPOINT [ "/bin/bash" ]