import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import yaml from 'js-yaml';

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = resolve(__dirname, '../..');
const config = yaml.load(readFileSync(resolve(REPO_ROOT, '_config.yml'), 'utf8'));

describe('_config.yml', () => {
  it('should be valid YAML', () => {
    assert.ok(config, 'Config should parse without errors');
    assert.equal(typeof config, 'object');
  });

  describe('site metadata', () => {
    it('should have a title', () => {
      assert.ok(config.title, 'title is required');
      assert.equal(typeof config.title, 'string');
    });

    it('should have an author', () => {
      assert.ok(config.author, 'author is required');
      assert.equal(typeof config.author, 'string');
    });

    it('should have a description', () => {
      assert.ok(config.description, 'description is required');
      assert.equal(typeof config.description, 'string');
    });

    it('should have a baseurl', () => {
      assert.ok(typeof config.baseurl === 'string', 'baseurl is required');
    });
  });

  describe('Jekyll settings', () => {
    it('should set a valid timezone', () => {
      assert.ok(config.timezone, 'timezone is required');
      assert.match(config.timezone, /^[A-Z][a-z]+\/[A-Z][a-z]+/);
    });

    it('should use kramdown as the markdown processor', () => {
      assert.equal(config.markdown, 'kramdown');
    });

    it('should use rouge as the syntax highlighter', () => {
      assert.equal(config.highlighter, 'rouge');
    });

    it('should have plugins configured', () => {
      assert.ok(Array.isArray(config.plugins), 'plugins should be an array');
      assert.ok(config.plugins.length > 0, 'plugins should not be empty');
    });

    it('should include jemoji plugin', () => {
      assert.ok(config.plugins.includes('jemoji'));
    });
  });

  describe('sass settings', () => {
    it('should have sass configuration', () => {
      assert.ok(config.sass, 'sass config is required');
    });

    it('should use compressed style', () => {
      assert.equal(config.sass.style, ':compressed');
    });
  });

  describe('reveal.js settings', () => {
    it('should have reveal configuration', () => {
      assert.ok(config.reveal, 'reveal config is required');
    });

    it('should enable keyboard navigation', () => {
      assert.equal(config.reveal.keyboard, true);
    });

    it('should enable touch navigation', () => {
      assert.equal(config.reveal.touch, true);
    });

    it('should enable history (URL hash)', () => {
      assert.equal(config.reveal.history, true);
    });

    it('should have a valid transition style', () => {
      const validTransitions = ['default', 'cube', 'page', 'concave', 'zoom', 'linear', 'fade', 'none'];
      assert.ok(validTransitions.includes(config.reveal.transition),
        `transition "${config.reveal.transition}" should be one of: ${validTransitions.join(', ')}`);
    });

    it('should set reasonable presentation dimensions', () => {
      assert.ok(config.reveal.width > 0, 'width should be positive');
      assert.ok(config.reveal.height > 0, 'height should be positive');
    });

    it('should set valid scale bounds', () => {
      assert.ok(config.reveal.minScale > 0, 'minScale should be positive');
      assert.ok(config.reveal.maxScale > config.reveal.minScale, 'maxScale should be greater than minScale');
    });

    it('should enable progress bar', () => {
      assert.equal(config.reveal.progress, true);
    });
  });

  describe('slide number settings', () => {
    it('should have slideNumber configuration', () => {
      assert.ok(config.slideNumber, 'slideNumber config is required');
    });

    it('should use a valid slide number format', () => {
      const validFormats = ['h.v', 'h/v', 'c', 'c/t', 'none'];
      assert.ok(validFormats.includes(config.slideNumber.format),
        `format "${config.slideNumber.format}" should be one of: ${validFormats.join(', ')}`);
    });
  });

  describe('solarized theme', () => {
    it('should have solarized configuration', () => {
      assert.ok(config.solarized, 'solarized config is required');
    });

    it('should use either dark or light theme', () => {
      assert.ok(['dark', 'light'].includes(config.solarized.theme),
        `theme should be "dark" or "light", got "${config.solarized.theme}"`);
    });
  });

  describe('exclude list', () => {
    it('should have an exclude list', () => {
      assert.ok(Array.isArray(config.exclude), 'exclude should be an array');
    });

    it('should exclude Gemfile', () => {
      assert.ok(config.exclude.includes('Gemfile'));
    });

    it('should exclude Gemfile.lock', () => {
      assert.ok(config.exclude.includes('Gemfile.lock'));
    });

    it('should exclude vendor directory', () => {
      assert.ok(config.exclude.includes('vendor'));
    });

    it('should exclude reveal.js test directory', () => {
      assert.ok(config.exclude.includes('reveal.js/test'));
    });
  });

  describe('kramdown settings', () => {
    it('should have kramdown configuration', () => {
      assert.ok(config.kramdown, 'kramdown config is required');
    });

    it('should configure smart quotes', () => {
      assert.ok(config.kramdown.smart_quotes, 'smart_quotes should be configured');
      assert.equal(typeof config.kramdown.smart_quotes, 'string');
    });
  });
});
