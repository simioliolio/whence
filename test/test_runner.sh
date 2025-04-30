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

cd "${PROJECT_ROOT}" || { echo "${PROJECT_ROOT} not found"; exit 1; }
busted .
