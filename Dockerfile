# Build stage
FROM debian:bookworm-slim AS builder

# Set build arg for target architecture
ARG TARGETARCH

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
ENV VAULT_VERSION=${VAULT_VERSION}
ARG TARGETARCH
RUN mkdir -p /tmp/build && cd /tmp/build && \
    curl -fsSL -o vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    curl -fsSL -o vault_${VAULT_VERSION}_SHA256SUMS https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
    curl -fsSL -o vault_${VAULT_VERSION}_SHA256SUMS.sig https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    grep vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip -d /usr/local/bin vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    cd / && rm -rf /tmp/build

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && apt-get install -y --no-install-recommends google-cloud-sdk && \
    rm -rf /var/lib/apt/lists/* && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image

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
    if [ -z "$TARGETARCH" ]; then echo "TARGETARCH is not set" >&2; exit 1; fi && \
    case "$TARGETARCH" in \
        amd64|arm64) DEB_ARCH="$TARGETARCH" ;; \
        *) echo "Unsupported TARGETARCH: $TARGETARCH" >&2; exit 1 ;; \
    esac && \
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$DEB_ARCH] https://mise.jdx.dev/deb stable main" | tee /etc/apt/sources.list.d/mise.list && \
    apt-get update && apt-get install -y --no-install-recommends mise && \
    rm -rf /var/lib/apt/lists/*

# Runtime stage
FROM debian:bookworm-slim

# Copy binaries and configurations from builder
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/share /usr/share
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /etc /etc
COPY --from=builder /root /root
COPY --from=builder /lib /lib

# Set environment variables
ENV PATH=/usr/local/bin:/usr/bin:$PATH
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
