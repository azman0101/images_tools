# DevOps Toolchain Docker Image

[![Dependabot Updates](https://github.com/azman0101/images_tools/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/azman0101/images_tools/actions/workflows/dependabot/dependabot-updates)
[![Docker](https://github.com/azman0101/images_tools/actions/workflows/docker.yml/badge.svg)](https://github.com/azman0101/images_tools/actions/workflows/docker.yml)

A comprehensive Docker container image that packages essential DevOps and cloud tools for development, operations, and infrastructure management tasks.

## 🚀 Included Tools

This container includes a curated set of tools commonly used in DevOps workflows:

### Cloud & Infrastructure
- **HashiCorp Vault** (v1.18.3) - Secrets management
- **Google Cloud SDK** (v505.0.0) - GCP command-line tools
- **MongoDB Client** (v8.0) - Database shell and tools

### Development & Build Tools
- **Node.js & Yarn** - JavaScript runtime and package manager
- **Python 3** - Python runtime and ecosystem
- **Build Essential** - GCC compiler and build tools
- **Git** - Version control
- **Vim** - Text editor

### Network & DNS Tools
- **dig, nslookup** - DNS lookup utilities
- **netcat** - Network connectivity tool
- **curl, wget** - HTTP clients
- **telnet** - Network protocol client

### Database Clients
- **MySQL Client** - MySQL database client
- **PostgreSQL Client** - PostgreSQL database client

### System & Utilities
- **jq** - JSON processor
- **unzip** - Archive utility
- **file** - File type identification
- **mise** - Runtime version manager

### Shell Environment
- **Zsh with Oh My Zsh** - Enhanced shell experience
- Custom configuration for development workflows

## 📦 Usage

### Pull the image
```bash
docker pull azman0101/images_tools:latest
```

### Run interactively
```bash
docker run -it azman0101/images_tools:latest
```

### Run with volume mounts
```bash
docker run -it -v $(pwd):/workspace azman0101/images_tools:latest
```

### Use in CI/CD pipelines
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    container:
      image: azman0101/images_tools:latest
    steps:
      - name: Use tools
        run: |
          gcloud version
          vault --version
          mongosh --version
```

## 🛠 Included Scripts

The container includes helpful network diagnostic scripts located in the root directory, useful for troubleshooting and validating connectivity in DevOps workflows:

- `load.sh` - Network load generation and basic DNS query testing
- `lookup_test.sh` - Automated DNS lookup and latency checks for network troubleshooting

## 🔧 Dependency Management

This repository uses **Renovate** for automated dependency updates that go beyond what Dependabot can handle.

### What's Managed by Renovate

- **HashiCorp Vault**: Automatically tracks and updates the `VAULT_VERSION` environment variable in the Dockerfile
- Monitors `hashicorp/vault` GitHub releases and creates pull requests when new versions are available

### What's Managed by Dependabot

- **Base Docker Images**: Updates `FROM` instructions (e.g., `debian:trixie-backports`)
- Standard package ecosystem dependencies

### How It Works

Renovate uses regex managers to parse the Dockerfile and identify version variables that need tracking:

```dockerfile
ENV VAULT_VERSION=1.18.3
```

When a new Vault release is published, Renovate will automatically:
1. Create a branch with the updated version
2. Open a pull request with the changes
3. Include release notes and changelogs

The Renovate workflow runs daily at 2 AM UTC and can also be triggered manually from the Actions tab.

## 🔄 Release Process

This repository uses [Release Please](https://github.com/googleapis/release-please) for automated release management. Releases are automatically created based on [Conventional Commits](https://www.conventionalcommits.org/).

To trigger a release:
1. Commit changes using conventional commit format (e.g., `feat:`, `fix:`, `chore:`)
2. Push to the `main` branch
3. Release Please will automatically create a pull request for the next release
4. When the release PR is merged, a new release will be created

## 📝 Contributing

Contributions are welcome! Please ensure your commits follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for automatic release management.
