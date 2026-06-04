#!/usr/bin/env bats

# Unit tests for script/setup

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

@test "setup script exists and is executable" {
  [ -x "$REPO_ROOT/script/setup" ]
}

@test "setup script starts with a valid shebang" {
  head -1 "$REPO_ROOT/script/setup" | grep -qE '^#!/bin/(ba)?sh'
}

@test "setup script uses 'set -e' for error handling" {
  grep -q 'set -e' "$REPO_ROOT/script/setup"
}

@test "setup script changes to repo root directory" {
  grep -q 'cd "$(dirname "$0")/.."' "$REPO_ROOT/script/setup"
}

@test "setup script checks for Brewfile on macOS" {
  grep -q 'Brewfile' "$REPO_ROOT/script/setup"
  grep -q 'uname -s.*Darwin' "$REPO_ROOT/script/setup"
}

@test "setup script checks for .ruby-version" {
  grep -q '.ruby-version' "$REPO_ROOT/script/setup"
}

@test "setup script installs gem dependencies when Gemfile exists" {
  grep -q 'bundle install' "$REPO_ROOT/script/setup"
}

@test "setup script initializes git submodules" {
  grep -q 'git submodule update --init' "$REPO_ROOT/script/setup"
}

@test "setup script prints completion message" {
  grep -q 'App is now ready to go' "$REPO_ROOT/script/setup"
}

@test "setup script bundle install uses --no-cache flag" {
  grep 'bundle install' "$REPO_ROOT/script/setup" | grep -q '\-\-no-cache'
}

@test "setup script bundle install excludes production group" {
  grep 'bundle install' "$REPO_ROOT/script/setup" | grep -q '\-\-without production'
}
