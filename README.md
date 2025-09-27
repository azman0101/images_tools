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

The container includes helpful scripts located in the root directory:

- `load.sh` - DNS performance testing and load generation
- `lookup_test.sh` - DNS lookup latency testing

## 🔄 Release Process

This repository uses [Release Please](https://github.com/googleapis/release-please) for automated release management. Releases are automatically created based on [Conventional Commits](https://www.conventionalcommits.org/).

To trigger a release:
1. Commit changes using conventional commit format (e.g., `feat:`, `fix:`, `chore:`)
2. Push to the `main` branch
3. Release Please will automatically create a pull request for the next release
4. When the release PR is merged, a new release will be created

## 📝 Contributing

Contributions are welcome! Please ensure your commits follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for automatic release management.
