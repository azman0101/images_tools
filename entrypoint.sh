#!/bin/bash
set -e

eval "$(ssh-agent)"

exec "$@"
