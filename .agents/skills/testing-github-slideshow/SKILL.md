---
name: testing-github-slideshow
description: Test the github-slideshow Jekyll/reveal.js app end-to-end. Use when verifying layout, styling, or asset path changes.
---

# Testing github-slideshow

## Overview
This is a Jekyll-based reveal.js slideshow project. It uses Jekyll layouts and includes to generate HTML presentations.

## Devin Secrets Needed
None required for local testing.

## Setup

1. Install Ruby and Jekyll (Ruby 3.x works):
   ```sh
   sudo apt-get install -y ruby ruby-dev build-essential zlib1g-dev
   sudo gem install bundler jekyll jemoji --no-document
   ```

2. The `Gemfile.lock` pins old gem versions incompatible with Ruby 3.x. Work around by temporarily moving it aside before building:
   ```sh
   cd /path/to/github-slideshow
   mv Gemfile Gemfile.bak && mv Gemfile.lock Gemfile.lock.bak
   ```

3. Jekyll does not copy `node_modules/` into `_site/` by default. For local testing, symlink it:
   ```sh
   jekyll build --baseurl "/github-slideshow" -d _site
   ln -s $(pwd)/node_modules _site/node_modules
   ```

4. Serve the site:
   ```sh
   jekyll serve --baseurl "/github-slideshow" --host 0.0.0.0 --port 4000
   ```
   Then open `http://localhost:4000/github-slideshow/` in Chrome.

## Key Test Points

### Layouts
- **Presentation layout** (`index.html` -> `presentation.html`): Should render with `<html class="dark">` (solarized theme), `<div class="reveal"><div class="slides">`, and include `script.html`.
- **Slide layout** (`_posts/*.md` -> `slide.html`): Should render with plain `<html>` (no class), `<div class="reveal"><div class="step">`.
- **Print layout** (`print.html`): Should render with plain `<html>`, `<div class="reveal">` without inner wrapper.

### Asset Paths
- All CSS/JS assets should load from `node_modules/reveal.js/` (check Network tab for 200s).
- The `reveal_path` config variable in `_config.yml` controls the path. Verify it resolves correctly in both `head.html` and `script.html`.

### Shell Scripts
- All scripts in `script/` source `script/_common.sh`. Test by running: `bash -c '. script/_common.sh && status "test"'`
- Verify `set -e`, `cd` to project root, and color variables work.

### Build Comparison
When testing refactoring changes, build on both the base and PR branches and diff the `_site` output:
```sh
git checkout main
jekyll build --baseurl "." -d /tmp/base_site
git checkout feature-branch
jekyll build --baseurl "." -d /tmp/pr_site
diff -r /tmp/base_site /tmp/pr_site
```
Only intentional changes should appear in the diff (no structural HTML differences).

## Known Issues
- The `Gemfile` requires `github-pages` gem which has many dependencies incompatible with newer Ruby. Moving Gemfile aside lets standalone Jekyll work fine for testing.
- `node_modules` must be symlinked into `_site` for local serving (not an issue on GitHub Pages).
- The `jemoji` plugin must be installed separately (`sudo gem install jemoji`).