#!/usr/bin/env bats

# Unit tests for script/stage

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"

@test "stage script exists and is executable" {
  [ -x "$REPO_ROOT/script/stage" ]
}

@test "stage script starts with a valid shebang" {
  head -1 "$REPO_ROOT/script/stage" | grep -qE '^#!/bin/(ba)?sh'
}

@test "stage script defines color variables for output" {
  grep -q "^red=" "$REPO_ROOT/script/stage"
  grep -q "^grn=" "$REPO_ROOT/script/stage"
  grep -q "^end=" "$REPO_ROOT/script/stage"
}

@test "stage script defaults to 'training-staging' account" {
  grep -q "account='training-staging'" "$REPO_ROOT/script/stage"
}

@test "stage script defaults repo name to 'caption-this'" {
  grep -q 'repo="caption-this"' "$REPO_ROOT/script/stage"
}

@test "stage script accepts custom repo name as first argument" {
  grep -q 'repo=$1' "$REPO_ROOT/script/stage"
}

@test "stage script builds Jekyll with DISABLE_WHITELIST" {
  grep -q 'DISABLE_WHITELIST=1 bundle exec jekyll build' "$REPO_ROOT/script/stage"
}

@test "stage script sets baseurl using account and repo" {
  grep 'jekyll build' "$REPO_ROOT/script/stage" | grep -q '/${account}/${repo}'
}

@test "stage script initializes a temp git repo in _site" {
  grep -q 'cd _site && git init' "$REPO_ROOT/script/stage"
}

@test "stage script pushes to gh-pages branch" {
  grep -q 'git push staging master:gh-pages' "$REPO_ROOT/script/stage"
}

@test "stage script force pushes the staging content" {
  grep 'git push' "$REPO_ROOT/script/stage" | grep -q '\-\-force'
}

@test "stage script cleans up remote after push" {
  grep -q 'git remote rm staging' "$REPO_ROOT/script/stage"
}

@test "stage script opens the staging site on completion" {
  grep -q 'open https://pages.ghe.io' "$REPO_ROOT/script/stage"
}
