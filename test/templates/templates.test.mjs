import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = resolve(__dirname, '../..');

function readTemplate(relPath) {
  return readFileSync(resolve(REPO_ROOT, relPath), 'utf8');
}

describe('_includes/head.html', () => {
  const content = readTemplate('_includes/head.html');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, '_includes/head.html')));
  });

  it('should set charset to utf-8', () => {
    assert.ok(content.includes('charset="utf-8"'));
  });

  it('should include viewport meta tag', () => {
    assert.ok(content.includes('name="viewport"'));
  });

  it('should disable user scaling for presentations', () => {
    assert.ok(content.includes('user-scalable=no'));
  });

  it('should include reveal.js CSS', () => {
    assert.ok(content.includes('reveal.css'));
  });

  it('should include reset.css', () => {
    assert.ok(content.includes('reset.css'));
  });

  it('should include a theme stylesheet', () => {
    assert.ok(content.includes('/css/theme/'));
  });

  it('should include syntax highlighting CSS', () => {
    assert.ok(content.includes('monokai.css'));
  });

  it('should have a title tag with Jekyll template logic', () => {
    assert.ok(content.includes('<title>'));
    assert.ok(content.includes('site.title'));
  });

  it('should handle print/PDF export styles', () => {
    assert.ok(content.includes('print-pdf'));
  });
});

describe('_includes/slide.html', () => {
  const content = readTemplate('_includes/slide.html');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, '_includes/slide.html')));
  });

  it('should use a <section> element', () => {
    assert.ok(content.includes('<section'));
  });

  it('should support optional slide IDs', () => {
    assert.ok(content.includes('post.slide-id'));
  });

  it('should apply the "step" CSS class', () => {
    assert.ok(content.includes('class="step'));
  });

  it('should render post title conditionally', () => {
    assert.ok(content.includes('post.title'));
    assert.ok(content.includes('<h1>'));
  });

  it('should render post content', () => {
    assert.ok(content.includes('post.content'));
  });

  it('should support custom CSS classes from front matter', () => {
    assert.ok(content.includes('post.classes'));
  });

  it('should support data attributes from front matter', () => {
    assert.ok(content.includes('post.data'));
    assert.ok(content.includes('data-'));
  });
});

describe('_includes/script.html', () => {
  const content = readTemplate('_includes/script.html');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, '_includes/script.html')));
  });

  it('should load reveal.js from node_modules', () => {
    assert.ok(content.includes('node_modules/reveal.js/js/reveal.js'));
  });

  it('should call Reveal.initialize()', () => {
    assert.ok(content.includes('Reveal.initialize'));
  });

  it('should enable URL hash support', () => {
    assert.ok(content.includes('hash: true'));
  });

  it('should load the markdown plugin (marked.js)', () => {
    assert.ok(content.includes('plugin/markdown/marked.js'));
  });

  it('should load the markdown renderer plugin', () => {
    assert.ok(content.includes('plugin/markdown/markdown.js'));
  });

  it('should load the syntax highlighting plugin', () => {
    assert.ok(content.includes('plugin/highlight/highlight.js'));
  });

  it('should load the speaker notes plugin asynchronously', () => {
    assert.ok(content.includes('plugin/notes/notes.js'));
    assert.ok(content.includes('async: true'));
  });
});

describe('_layouts/presentation.html', () => {
  const content = readTemplate('_layouts/presentation.html');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, '_layouts/presentation.html')));
  });

  it('should have a valid DOCTYPE', () => {
    assert.ok(content.includes('<!DOCTYPE html>'));
  });

  it('should include head.html partial', () => {
    assert.ok(content.includes('{% include head.html %}'));
  });

  it('should include script.html partial', () => {
    assert.ok(content.includes('{% include script.html %}'));
  });

  it('should have the reveal container structure', () => {
    assert.ok(content.includes('class="reveal"'));
    assert.ok(content.includes('class="slides"'));
  });

  it('should render content inside slides div', () => {
    assert.ok(content.includes('{{ content }}'));
  });

  it('should apply solarized theme class to html element', () => {
    assert.ok(content.includes('site.solarized.theme'));
  });

  it('should default to dark theme', () => {
    assert.ok(content.includes('dark'));
  });
});

describe('_layouts/slide.html', () => {
  const content = readTemplate('_layouts/slide.html');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, '_layouts/slide.html')));
  });

  it('should have a valid DOCTYPE', () => {
    assert.ok(content.includes('<!DOCTYPE html>'));
  });

  it('should include head.html partial', () => {
    assert.ok(content.includes('{% include head.html %}'));
  });

  it('should have the reveal container', () => {
    assert.ok(content.includes('class="reveal"'));
  });

  it('should use the step class', () => {
    assert.ok(content.includes('class="step"'));
  });

  it('should render content', () => {
    assert.ok(content.includes('{{ content }}'));
  });
});

describe('_layouts/print.html', () => {
  const content = readTemplate('_layouts/print.html');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, '_layouts/print.html')));
  });

  it('should have a valid DOCTYPE', () => {
    assert.ok(content.includes('<!DOCTYPE html>'));
  });

  it('should include head.html partial', () => {
    assert.ok(content.includes('{% include head.html %}'));
  });

  it('should have the reveal container', () => {
    assert.ok(content.includes('class="reveal"'));
  });

  it('should render content directly (no step wrapper)', () => {
    assert.ok(content.includes('{{ content }}'));
    assert.ok(!content.includes('class="step"'), 'print layout should not wrap in step class');
  });

  it('should not include script.html (no JS needed for print)', () => {
    assert.ok(!content.includes('script.html'), 'print layout should not include script.html');
  });
});

describe('index.html', () => {
  const content = readTemplate('index.html');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, 'index.html')));
  });

  it('should use the presentation layout', () => {
    assert.ok(content.includes('layout: presentation'));
  });

  it('should iterate over posts in reverse order', () => {
    assert.ok(content.includes('site.posts reversed'));
  });

  it('should include slide.html partial for each post', () => {
    assert.ok(content.includes('{% include slide.html %}'));
  });

  it('should add page-break divs between slides', () => {
    assert.ok(content.includes('class="page-break"'));
  });

  it('should conditionally render overview section', () => {
    assert.ok(content.includes('site.overview'));
    assert.ok(content.includes('id="overview"'));
  });

  it('should respect simple-slideshow flag', () => {
    assert.ok(content.includes('site.simple-slideshow'));
  });
});

describe('_posts/0000-01-01-intro.md', () => {
  const content = readTemplate('_posts/0000-01-01-intro.md');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, '_posts/0000-01-01-intro.md')));
  });

  it('should have YAML front matter', () => {
    assert.ok(content.startsWith('---'));
    const parts = content.split('---');
    assert.ok(parts.length >= 3, 'should have opening and closing front matter delimiters');
  });

  it('should use the slide layout', () => {
    assert.ok(content.includes('layout: slide'));
  });

  it('should have a title', () => {
    assert.ok(content.includes('title:'));
  });

  it('should have introductory content', () => {
    assert.ok(content.includes('right arrow'));
  });
});

describe('Gemfile', () => {
  const content = readTemplate('Gemfile');

  it('should exist', () => {
    assert.ok(existsSync(resolve(REPO_ROOT, 'Gemfile')));
  });

  it('should use rubygems.org as the source', () => {
    assert.ok(content.includes('source "https://rubygems.org"'));
  });

  it('should depend on github-pages gem', () => {
    assert.ok(content.includes('github-pages'));
  });

  it('should depend on html-proofer gem', () => {
    assert.ok(content.includes('html-proofer'));
  });
});
