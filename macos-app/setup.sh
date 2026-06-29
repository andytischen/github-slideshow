#!/bin/sh
#
# Copies reveal.js assets from the repo's node_modules into the
# Presentation/ folder and generates a self-contained index.html
# from the slides in _posts/.
#
# Run this before opening the Xcode project:
#   cd macos-app && ./setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEST="$SCRIPT_DIR/Presentation"
REVEAL="$REPO_ROOT/node_modules/reveal.js"

if [ ! -d "$REVEAL" ]; then
  echo "Error: reveal.js not found at $REVEAL" >&2
  echo "Run 'npm install' in the repo root first." >&2
  exit 1
fi

# Clean and recreate
rm -rf "$DEST"
mkdir -p "$DEST/css/theme" "$DEST/css/print" "$DEST/js" \
         "$DEST/lib/css" \
         "$DEST/plugin/markdown" "$DEST/plugin/highlight" "$DEST/plugin/notes"

echo "Copying reveal.js assets..."
cp "$REVEAL/css/reset.css"               "$DEST/css/"
cp "$REVEAL/css/reveal.css"              "$DEST/css/"
cp "$REVEAL/css/theme/moon.css"          "$DEST/css/theme/"
cp -R "$REVEAL/css/print/."             "$DEST/css/print/"
cp "$REVEAL/lib/css/monokai.css"         "$DEST/lib/css/"
cp "$REVEAL/js/reveal.js"               "$DEST/js/"
cp "$REVEAL/plugin/markdown/marked.js"   "$DEST/plugin/markdown/"
cp "$REVEAL/plugin/markdown/markdown.js" "$DEST/plugin/markdown/"
cp "$REVEAL/plugin/highlight/highlight.js" "$DEST/plugin/highlight/"
cp "$REVEAL/plugin/notes/notes.js"       "$DEST/plugin/notes/"

# --- Generate index.html from _posts/ ---
POSTS_DIR="$REPO_ROOT/_posts"
SLIDES=""

if [ -d "$POSTS_DIR" ]; then
  for post in $(ls "$POSTS_DIR"/*.md 2>/dev/null | sort); do
    # Extract title from YAML front matter
    title=$(sed -n 's/^title: *//p' "$post" | head -1 | sed 's/^"//;s/"$//')
    # Extract body (everything after the second ---)
    body=$(awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' "$post")

    SLIDES="$SLIDES
      <section class=\"step slide\">
        $([ -n "$title" ] && echo "<h1>$title</h1>")
        $body
      </section>"
  done
fi

# Fallback if no slides found
if [ -z "$SLIDES" ]; then
  SLIDES='<section class="step slide"><h1>No slides found</h1><p>Add Markdown files to _posts/ and re-run setup.sh.</p></section>'
fi

echo "Generating index.html..."
cat > "$DEST/index.html" << HTMLEOF
<!DOCTYPE html>
<html class="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>GitHub Slideshow</title>
  <link rel="stylesheet" href="css/reset.css">
  <link rel="stylesheet" href="css/reveal.css">
  <link rel="stylesheet" href="css/theme/moon.css">
  <link rel="stylesheet" href="lib/css/monokai.css">
</head>
<body>
  <div class="reveal">
    <div class="slides">
$SLIDES
    </div>
  </div>

  <script src="js/reveal.js"></script>
  <script>
    (function() {
      if (typeof Reveal === 'undefined') {
        console.error('reveal.js failed to load');
        document.body.innerHTML =
          '<p style="padding:2rem;color:#e94560;font-family:system-ui;">Error: reveal.js failed to load.</p>';
        return;
      }
      Reveal.initialize({
        hash: true,
        controls: false,
        progress: true,
        history: true,
        keyboard: true,
        overview: true,
        center: true,
        touch: true,
        loop: false,
        fragments: true,
        transition: 'linear',
        backgroundTransition: 'slide',
        width: 1000,
        height: 920,
        margin: 0.1,
        minScale: 0.2,
        maxScale: 1.5,
        dependencies: [
          { src: 'plugin/markdown/marked.js' },
          { src: 'plugin/markdown/markdown.js' },
          { src: 'plugin/highlight/highlight.js' },
          { src: 'plugin/notes/notes.js', async: true }
        ]
      }).catch(function(err) {
        console.error('Reveal.initialize failed:', err);
      });
    })();
  </script>
</body>
</html>
HTMLEOF

echo "Done. Presentation assets are in $DEST"
echo "Open GitHubSlideshow.xcodeproj in Xcode to build and run."
