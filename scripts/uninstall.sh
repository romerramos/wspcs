#!/bin/bash
set -e

# Workspace Manager Uninstallation Script
# Usage: curl -sSL https://raw.githubusercontent.com/romerramos/wspcs/main/scripts/uninstall.sh | bash

BINARY_NAME="wspcs"

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

# Find and remove binary
remove_binary() {
  local binary_path=""

  # Check common installation locations
  local locations=(
    "/usr/local/bin/${BINARY_NAME}"
    "/usr/bin/${BINARY_NAME}"
    "$HOME/.local/bin/${BINARY_NAME}"
    "$HOME/bin/${BINARY_NAME}"
  )

  # Also check PATH
  if command -v "$BINARY_NAME" >/dev/null 2>&1; then
    binary_path=$(command -v "$BINARY_NAME")
    locations+=("$binary_path")
  fi

  local found=false
  for location in "${locations[@]}"; do
    if [[ -f "$location" ]]; then
      log "Found ${BINARY_NAME} at: $location"

      # Check if we have write permission
      if [[ -w "$location" ]] || [[ -w "$(dirname "$location")" ]]; then
        rm "$location" && log "Removed: $location"
        found=true
      else
        warn "No permission to remove: $location"
        warn "Run with sudo to remove system-wide installation"
        return 1
      fi
    fi
  done

  if [[ "$found" == false ]]; then
    warn "No installation of ${BINARY_NAME} found"
    return 1
  fi

  return 0
}

# Verify removal
verify_removal() {
  if command -v "$BINARY_NAME" >/dev/null 2>&1; then
    warn "${BINARY_NAME} still found in PATH. You may need to restart your terminal."
  else
    log "Successfully uninstalled ${BINARY_NAME}"
  fi
}

# Main uninstallation process
main() {
  log "Uninstalling Workspace Manager..."

  if remove_binary; then
    verify_removal
    log "Uninstallation complete!"
  else
    error "Failed to uninstall ${BINARY_NAME}"
  fi
}

# Run main function
main "$@"

