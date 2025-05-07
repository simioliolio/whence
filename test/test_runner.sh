#!/bin/bash

# Check if busted (Lua test framework) is available in PATH
if [ -z "$(which busted)" ]; then
  echo "busted not found on PATH. Please install it (via Homebrew or similar)"
  exit 1
fi

# Norns ensures that a script's parent directory in on path before running. If a script's
# includes / requires are relative to the script's parent directory, then there is little
# chance that another script may accidentally require / include the wrong file.
#
# When running tests, we also need to ensure the parent directory is on path. This allows
# the same requires / includes to work on norns as well as in tests. However, adding the
# scripts parent directory may result in tests taking a long time to resolve requires /
# includes due to there potentially being a lot of files in the parent directory (ie,
# all of a developers lua projects etc).
#
# This script copies the repo to a temp directory and runs tests from the same directory.
# This ensures that tests run quickly and that requires / includes work as expected.

# Assumes project_root/test/test_runner.sh. Update below logic if this file moves.
TEST_DIR="$(dirname "$(readlink -f "$0")")"
PROJECT_ROOT="$(dirname "$TEST_DIR")"

# Create a temporary directory for testing
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Copy the entire repository
mkdir -p "$TEMP_DIR/whence"
cp -r "$PROJECT_ROOT"/* "$TEMP_DIR/whence/"

# Change to the temporary directory
cd "$TEMP_DIR" || { echo "Failed to change to temporary directory"; exit 1; }

# Add our test environment to LUA_PATH
export LUA_PATH="./?.lua;./?/init.lua;./?/?.lua"

# Run the tests
busted .
