
# FROM debian:bullseye as build-env

# RUN apt update && apt-get install -y  bind9utils build-essential curl jq libbind-dev libcap-dev libgeoip-dev libjson-c-dev libkrb5-dev libssl-dev libxml2-dev postgresql-client python3 unzip wget zsh

FROM debian:bullseye-slim

RUN export DEBIAN_FRONTEND=noninteractive && for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done && apt update && apt install -qqy apt-transport-https bash bind9utils build-essential ca-certificates curl default-mysql-client dnsutils file gnupg gnupg2 jq msmtp-mta nodejs postgresql-client python3 telnet unzip vim wget zsh netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

ENV VAULT_VERSION 1.8.5

RUN mkdir -p /tmp/build \
    && cd /tmp/build \
    && wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip  \
    && wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS \
    && wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig \
    && grep vault_${VAULT_VERSION}_linux_amd64.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c \
    && unzip -d /usr/local/bin vault_${VAULT_VERSION}_linux_amd64.zip \
    && cd /tmp \
    && rm -rf /tmp/build

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


RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
RUN apt update && apt search mongodb && apt-get install mongodb-org-shell=4.4.10 -qqy

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install git yarn unzip -qqy && \
    yarn global add aws-es-curl

RUN ( curl https://sh.rustup.rs -sSf | sh -s -- -y ) && . "$HOME/.cargo/env"

RUN cargo install starship --locked

RUN chsh -s /bin/zsh root

COPY ./scripts /
COPY README.md /

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
#USER vault
COPY ./zshrc /root/.zshrc

ENTRYPOINT [ "/bin/zsh" ]
