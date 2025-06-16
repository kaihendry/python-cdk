#!/bin/bash
set -e

# Install uv if not already installed
if ! command -v uv &>/dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

uv venv --no-managed-python
uv sync

# uv tool install pre-commit --with pre-commit-uv
# pre-commit install --install-hooks

git config --global --add --bool push.autoSetupRemote true

# Display authentication status
echo "=== Authentication Status ==="
echo "AWS: Run '.devcontainer/scripts/aws-auth.sh' to authenticate"

# Display container information if available
if command -v devcontainer-info &> /dev/null; then
    devcontainer-info
fi