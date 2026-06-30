#!/usr/bin/env bats

# Unit tests for script/server

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

@test "server script exists and is executable" {
  [ -x "$REPO_ROOT/script/server" ]
}

@test "server script starts with a valid shebang" {
  head -1 "$REPO_ROOT/script/server" | grep -qE '^#!/bin/(ba)?sh'
}

@test "server script uses 'set -e' for error handling" {
  grep -q 'set -e' "$REPO_ROOT/script/server"
}

@test "server script uses bundle exec jekyll serve" {
  grep -q 'bundle exec jekyll serve' "$REPO_ROOT/script/server"
}

@test "server script passes through additional arguments" {
  grep -q '"$@"' "$REPO_ROOT/script/server"
}
