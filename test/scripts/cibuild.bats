#!/usr/bin/env bats

# Unit tests for script/cibuild

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

@test "cibuild script exists and is executable" {
  [ -x "$REPO_ROOT/script/cibuild" ]
}

@test "cibuild script starts with a valid shebang" {
  head -1 "$REPO_ROOT/script/cibuild" | grep -qE '^#!/bin/(ba)?sh'
}

@test "cibuild script uses 'set -e' for error handling" {
  grep -q 'set -e' "$REPO_ROOT/script/cibuild"
}

@test "cibuild script builds Jekyll site with baseurl" {
  grep -q 'bundle exec jekyll build' "$REPO_ROOT/script/cibuild"
  grep -q '\-\-baseurl' "$REPO_ROOT/script/cibuild"
}

@test "cibuild script sets baseurl to current directory" {
  grep 'jekyll build' "$REPO_ROOT/script/cibuild" | grep -q '\-\-baseurl "."'
}

@test "cibuild script runs htmlproofer on generated site" {
  grep -q 'htmlproofer' "$REPO_ROOT/script/cibuild"
}

@test "cibuild script proofs the index.html in _site" {
  grep 'htmlproofer' "$REPO_ROOT/script/cibuild" | grep -q '_site/index.html'
}

@test "cibuild script ignores empty alt attributes" {
  grep 'htmlproofer' "$REPO_ROOT/script/cibuild" | grep -q '\-\-empty-alt-ignore'
}
