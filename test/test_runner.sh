#!/bin/bash

# Run busted from project root to allow project-relative `requires` to work as expected.

# Assumes project_root/test/test_runner.sh. Update below logic if this file moves.
TEST_DIR="$(dirname "$(readlink -f "$0")")"
PROJECT_ROOT="$(dirname "$TEST_DIR")"

# Check if busted (Lua test framework) is available in PATH
if [ -z "$(which busted)" ]; then
  echo "busted not found on PATH. Please install it (via Homebrew or similar)"
  exit 1
fi

# Create a temporary directory for testing
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Create the minimal directory structure needed for testing
mkdir -p "$TEMP_DIR/lib"
mkdir -p "$TEMP_DIR/test/utils"

# Copy only the necessary files
cp -r "$PROJECT_ROOT/lib"/* "$TEMP_DIR/lib/"
cp "$PROJECT_ROOT/whence.lua" "$TEMP_DIR/whence.lua"
cp -r "$PROJECT_ROOT/test/utils"/* "$TEMP_DIR/test/utils/"

# Change to the temporary directory
cd "$TEMP_DIR" || { echo "Failed to change to temporary directory"; exit 1; }

# Set LUA_PATH to include only our test environment
export LUA_PATH="./?.lua;./?/init.lua;./?/?.lua"

# Run the tests
busted "$PROJECT_ROOT/test/lib"
