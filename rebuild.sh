#!/usr/bin/env bash

# Auto-detect host and rebuild configuration
# Usage: ./rebuild.sh [--boot] [additional args...]

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detect current host
HOST=$(hostname)

case $HOST in
  "nixos")
    FLAKE_PATH="$SCRIPT_DIR/nixos#nixos-desktop"
    REBUILD_CMD="sudo nixos-rebuild"
    PLATFORM="NixOS"
    ;;
  "Bradens-MacBook-Air")
    FLAKE_PATH="$SCRIPT_DIR/darwin#macbook-air"
    REBUILD_CMD="sudo darwin-rebuild"
    PLATFORM="Darwin"
    ;;
  "BradensacStudio.home")
    FLAKE_PATH="$SCRIPT_DIR/darwin#mac-mini"
    REBUILD_CMD="sudo darwin-rebuild"
    PLATFORM="Darwin"
    ;;
  *)
    echo "Unknown host: $HOST"
    echo "Please manually specify the flake target"
    echo "Available targets:"
    echo "  NixOS: nixos#nixos-desktop"
    echo "  Darwin: darwin#macbook-air"
    echo "  Darwin: darwin#mac-mini"
    exit 1
    ;;
esac

# Handle --boot flag for NixOS
ACTION="switch"
EXTRA_ARGS=()

for arg in "$@"; do
  if [[ "$arg" == "--boot" ]]; then
    if [[ "$PLATFORM" == "NixOS" ]]; then
      ACTION="boot"
    else
      echo "Warning: --boot flag is only supported on NixOS, ignoring..."
    fi
  else
    EXTRA_ARGS+=("$arg")
  fi
done

echo "Rebuilding $HOST ($PLATFORM using $FLAKE_PATH)..."

# Run rebuild
$REBUILD_CMD $ACTION --flake "$FLAKE_PATH" "${EXTRA_ARGS[@]}"
