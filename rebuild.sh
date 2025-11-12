#!/usr/bin/env bash

# Auto-detect host and rebuild configuration
# Usage: ./rebuild.sh [--boot] [--diff|--compare] [additional args...]

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detect current host
HOST=$(hostname)

case $HOST in
  "nixos")
    FLAKE_PATH="$SCRIPT_DIR/nixos#nixos-desktop"
    BASE_REBUILD_CMD="nixos-rebuild"
    NEEDS_SUDO=true
    PLATFORM="NixOS"
    CURRENT_SYSTEM="/run/current-system"
    ;;
  "Bradens-MacBook-Air")
    FLAKE_PATH="$SCRIPT_DIR/darwin#macbook-air"
    BASE_REBUILD_CMD="darwin-rebuild"
    NEEDS_SUDO=true
    PLATFORM="Darwin"
    CURRENT_SYSTEM="/run/current-system"
    ;;
  "Bradens-Mac-Studio")
    FLAKE_PATH="$SCRIPT_DIR/darwin#mac-studio"
    BASE_REBUILD_CMD="darwin-rebuild"
    NEEDS_SUDO=true
    PLATFORM="Darwin"
    CURRENT_SYSTEM="/run/current-system"
    ;;
  *)
    echo "Unknown host: $HOST"
    echo "Please manually specify the flake target"
    echo "Available targets:"
    echo "  NixOS: nixos#nixos-desktop"
    echo "  Darwin: darwin#macbook-air"
    echo "  Darwin: darwin#mac-studio"
    exit 1
    ;;
esac

# Handle arguments
ACTION="switch"
DIFF_MODE=false
EXTRA_ARGS=()

for arg in "$@"; do
  if [[ "$arg" == "--boot" ]]; then
    if [[ "$PLATFORM" == "NixOS" ]]; then
      ACTION="boot"
    else
      echo "Warning: --boot flag is only supported on NixOS, ignoring..."
    fi
  elif [[ "$arg" == "--diff" || "$arg" == "--compare" ]]; then
    DIFF_MODE=true
  else
    EXTRA_ARGS+=("$arg")
  fi
done

if [[ "$DIFF_MODE" == true ]]; then
  echo "Building configuration for $HOST ($PLATFORM) to compare changes..."
  echo ""
  
  # Build without switching (no sudo needed!)
  echo "→ Running build..."
  echo "   Command: $BASE_REBUILD_CMD build --flake \"$FLAKE_PATH\" ${EXTRA_ARGS[*]}"
  echo ""
  $BASE_REBUILD_CMD build --flake "$FLAKE_PATH" "${EXTRA_ARGS[@]}"
  BUILD_EXIT=$?
  
  if [[ $BUILD_EXIT -ne 0 ]]; then
    echo ""
    echo "❌ Build failed! Cannot compare."
    exit $BUILD_EXIT
  fi
  
  echo ""
  echo "✓ Build successful!"
  echo ""
  
  # Check if nvd is available
  if ! command -v nvd &> /dev/null; then
    echo "⚠️  nvd not found. Install it with: nix-shell -p nvd"
    echo ""
    echo "Falling back to nix store diff..."
    nix store diff-closures "$CURRENT_SYSTEM" ./result
  else
    echo "→ Comparing with current system using nvd..."
    echo ""
    nvd diff "$CURRENT_SYSTEM" ./result
  fi
  
  echo ""
  echo "To apply these changes, run: ./rebuild.sh"
  
else
  # Normal rebuild (switch/boot)
  echo "Rebuilding $HOST ($PLATFORM using $FLAKE_PATH)..."
  
  # Run rebuild (with sudo if needed)
  if [[ "$NEEDS_SUDO" == true ]]; then
    echo "   Command: sudo $BASE_REBUILD_CMD $ACTION --flake \"$FLAKE_PATH\" ${EXTRA_ARGS[*]}"
    echo ""
    sudo $BASE_REBUILD_CMD $ACTION --flake "$FLAKE_PATH" "${EXTRA_ARGS[@]}"
  else
    echo "   Command: $BASE_REBUILD_CMD $ACTION --flake \"$FLAKE_PATH\" ${EXTRA_ARGS[*]}"
    echo ""
    $BASE_REBUILD_CMD $ACTION --flake "$FLAKE_PATH" "${EXTRA_ARGS[@]}"
  fi
fi
