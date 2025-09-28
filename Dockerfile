# Build stage
FROM debian:trixie-slim AS builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    bash \
    bind9utils \
    build-essential \
    ca-certificates \
    curl \
    default-mysql-client \
    dnsutils \
    file \
    gnupg \
    gnupg2 \
    jq \
    msmtp-mta \
    nodejs \
    postgresql-client \
    python3 \
    telnet \
    unzip \
    vim \
    wget \
    zsh \
    netcat-openbsd \
    git \
    gpg \
    && rm -rf /var/lib/apt/lists/*

# Install Vault
ARG VAULT_VERSION=1.18.3
RUN mkdir -p /tmp/build && cd /tmp/build && \
    curl -fsSL -o vault_${VAULT_VERSION}_linux_amd64.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    curl -fsSL -o vault_${VAULT_VERSION}_SHA256SUMS https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
    curl -fsSL -o vault_${VAULT_VERSION}_SHA256SUMS.sig https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    grep vault_${VAULT_VERSION}_linux_amd64.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip -d /usr/local/bin vault_${VAULT_VERSION}_linux_amd64.zip && \
    cd / && rm -rf /tmp/build

# Install Google Cloud SDK
ARG CLOUD_SDK_VERSION=505.0.0
RUN curl -LO "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz" && \
    tar xzf "google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz" -C / && \
    rm "google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz" && \
    ln -s /lib /lib64 && \
    rm -rf /google-cloud-sdk/.install/.backup

# Configure GCS
RUN /google-cloud-sdk/bin/gcloud config set core/disable_usage_reporting true && \
    /google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check true && \
    /google-cloud-sdk/bin/gcloud config set metrics/environment github_docker_image

# Install MongoDB shell
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor && \
    echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && apt-get install -y --no-install-recommends mongodb-org-shell && \
    rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y --no-install-recommends yarn && \
    yarn global add aws-es-curl && \
    rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Mise
RUN install -dm 755 /etc/apt/keyrings && \
    wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | tee /etc/apt/sources.list.d/mise.list && \
    apt-get update && apt-get install -y --no-install-recommends mise && \
    rm -rf /var/lib/apt/lists/*

# Runtime stage
FROM debian:trixie-slim

# Copy binaries and configurations from builder
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /google-cloud-sdk /google-cloud-sdk
COPY --from=builder /usr/share /usr/share
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /etc /etc
COPY --from=builder /root /root
COPY --from=builder /lib /lib
COPY --from=builder /lib64 /lib64

# Set environment variables
ENV PATH=/google-cloud-sdk/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Copy scripts and README
COPY ./scripts /
COPY README.md /

# Copy zshrc
COPY ./zshrc /root/.zshrc

# Set shell
RUN chsh -s /bin/zsh root

# Default command
CMD ["/bin/zsh"]
