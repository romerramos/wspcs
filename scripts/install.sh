#!/bin/bash
set -e

# Workspace Manager Installation Script
# Usage: curl -sSL https://raw.githubusercontent.com/romerramos/wspcs/main/scripts/install.sh | bash

BINARY_NAME="wspcs"
INSTALL_DIR="/usr/local/bin"
GITHUB_REPO="romerramos/wspcs"
VERSION="latest"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Detect OS and architecture
detect_platform() {
  local os=""
  local arch=""

  case "$(uname -s)" in
  Darwin*) os="mac" ;;
  Linux*) os="linux" ;;
  CYGWIN* | MINGW* | MSYS*) os="windows" ;;
  *) error "Unsupported operating system: $(uname -s)" ;;
  esac

  case "$(uname -m)" in
  x86_64 | amd64) arch="amd64" ;;
  arm64 | aarch64) arch="arm64" ;;
  *) error "Unsupported architecture: $(uname -m)" ;;
  esac

  echo "${os}-${arch}"
}

# Check if running as root for system-wide installation
check_permissions() {
  if [[ $EUID -eq 0 ]]; then
    log "Installing system-wide to ${INSTALL_DIR}"
  elif [[ -w "$INSTALL_DIR" ]]; then
    log "Installing to ${INSTALL_DIR}"
  else
    warn "No write permission to ${INSTALL_DIR}. You may need to run with sudo."
    INSTALL_DIR="$HOME/.local/bin"
    log "Installing to user directory: ${INSTALL_DIR}"
    mkdir -p "$INSTALL_DIR"

    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
      warn "Add $INSTALL_DIR to your PATH by adding this to your shell profile:"
      echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
    fi
  fi
}

# Download and install binary
install_binary() {
  local platform=$(detect_platform)
  local binary_name="${BINARY_NAME}-${platform}"

  if [[ "$platform" == *"windows"* ]]; then
    binary_name="${binary_name}.exe"
  fi

  # Get the latest release version using GitHub API (first release in the list)
  local latest_version=$(curl -sSL "https://api.github.com/repos/${GITHUB_REPO}/releases" | grep '"tag_name":' | head -1 | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

  if [[ -z "$latest_version" ]]; then
    error "Failed to get latest release version"
  fi

  local download_url="https://github.com/${GITHUB_REPO}/releases/download/${latest_version}/${binary_name}"
  local temp_file="/tmp/${binary_name}"

  log "Detected platform: ${platform}"
  log "Latest version: ${latest_version}"
  log "Downloading from: ${download_url}"

  # Download binary
  if command -v curl >/dev/null 2>&1; then
    curl -sSL "$download_url" -o "$temp_file" || error "Failed to download binary"
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$download_url" -O "$temp_file" || error "Failed to download binary"
  else
    error "Neither curl nor wget is available. Please install one of them."
  fi

  # Make executable and move to install directory
  chmod +x "$temp_file"
  mv "$temp_file" "${INSTALL_DIR}/${BINARY_NAME}" || error "Failed to install binary"

  log "Successfully installed ${BINARY_NAME} to ${INSTALL_DIR}"
}

# Verify installation
verify_installation() {
  if command -v "$BINARY_NAME" >/dev/null 2>&1; then
    log "Installation verified! Run '${BINARY_NAME} -h' to get started."
  else
    warn "Binary installed but not found in PATH. You may need to restart your terminal or update your PATH."
  fi
}

# Main installation process
main() {
  log "Installing Workspace Manager..."

  check_permissions
  install_binary
  verify_installation

  log "Installation complete!"
  log "Create a workspace config file and run: ${BINARY_NAME} -f your-workspace.yml"
}

# Run main function
main "$@"
