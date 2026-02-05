#!/bin/bash

echo "This script will install the Auro package manager."

# Check for root/sudo access
if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

# Get the real user's home directory (not root's)
if [[ -n "$SUDO_USER" ]]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_HOME="$HOME"
fi

# Create necessary directories
mkdir -p "$REAL_HOME/.keg/bin"
mkdir -p "$REAL_HOME/.keg/data"
mkdir -p "$REAL_HOME/.keg/installed"

# Copy auro script to bin directory
cp "$(dirname "$0")/keg" "$REAL_HOME/.keg/bin/auro"

# Make auro executable
chmod +x "$REAL_HOME/.keg/bin/auro"

# Add auro to user's PATH if not already present
if ! grep -q '.keg/bin' "$REAL_HOME/.bashrc"; then
    echo 'export PATH="$HOME/.keg/bin:$PATH"' >> "$REAL_HOME/.bashrc"
fi

echo "Auro has been installed successfully!"
echo "Run 'source ~/.bashrc' or restart your terminal to use auro."