# dnsperf
[![Dependabot Updates](https://github.com/azman0101/images_tools/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/azman0101/images_tools/actions/workflows/dependabot/dependabot-updates)

## Release Process

This repository uses [Release Please](https://github.com/googleapis/release-please) for automated release management. Releases are automatically created based on [Conventional Commits](https://www.conventionalcommits.org/).

To trigger a release:
1. Commit changes using conventional commit format (e.g., `feat:`, `fix:`, `chore:`)
2. Push to the `main` branch
3. Release Please will automatically create a pull request for the next release
4. When the release PR is merged, a new release will be created
