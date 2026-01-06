#!/bin/bash
# Install script for workon

set -e

INSTALL_DIR="${INSTALL_DIR:-$HOME/bin}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing workon..."

# Create install directory if needed
mkdir -p "$INSTALL_DIR"

# Copy script
cp "$SCRIPT_DIR/workon" "$INSTALL_DIR/workon"
chmod +x "$INSTALL_DIR/workon"

echo "✓ Installed to $INSTALL_DIR/workon"

# Check if in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Note: $INSTALL_DIR is not in your PATH."
    echo "Add this to your shell profile (~/.zshrc or ~/.bashrc):"
    echo ""
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
fi

echo ""
echo "Usage: workon --help"
