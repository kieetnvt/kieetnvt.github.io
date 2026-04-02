# Multilingual Jekyll Blog - Vietnamese Support

This project now supports Vietnamese translations! 🇻🇳

## Structure

```
/
├── _posts/              # English blog posts
├── vi/                  # Vietnamese versions
│   ├── _posts/         # Vietnamese blog posts
│   ├── index.html      # Vietnamese home page
│   └── aboutme.md      # Vietnamese about page
├── _config.yml          # Updated with language settings
└── _includes/
    └── lang-switcher.html   # Language toggle component
```

## How to Add Vietnamese Translations

### Method 1: Automatic (Recommended)

Use the provided Ruby script to create Vietnamese post templates:

```bash
ruby create_vietnamese_posts.rb
```

This will:
- Create Vietnamese versions of all posts in `vi/_posts/`
- Add `lang: vi` and `ref` fields to front matter
- Add translation notes to guide you

Then just translate the content!

### Method 2: Manual

1. Create a new file in `vi/_posts/` with the same filename as the English version
2. Copy the English post content
3. Add `lang: vi` and `ref: post-slug` to the front matter
4. Translate the content

Example front matter:
```yaml
---
layout: post
title: "Tiêu đề tiếng Việt"
subtitle: "Phụ đề tiếng Việt"
lang: vi
ref: post-slug-name
tags: [react, javascript]
---
```

## URLs

- English: `https://yoursite.com/2026-04-02-post-name/`
- Vietnamese: `https://yoursite.com/vi/2026-04-02-post-name/`

## Language Switcher

The language switcher appears at the top of each post, allowing readers to switch between English and Vietnamese versions.

## Testing Locally

```bash
bundle exec jekyll serve
```

Then visit:
- English: http://localhost:4000
- Vietnamese: http://localhost:4000/vi/

## Configuration

Key settings in `_config.yml`:

```yaml
languages: ["en", "vi"]
default_lang: "en"
```

UI translations are in `_data/ui-text.yml` (Vietnamese translations already included).

## Next Steps

1. Run `ruby create_vietnamese_posts.rb` to generate post templates
2. Translate content in `vi/_posts/` files
3. Update titles, subtitles, and tags to Vietnamese
4. Test locally with `bundle exec jekyll serve`
5. Commit and push to GitHub Pages

## Tips

- The `ref` field in front matter links English and Vietnamese versions of the same post
- Keep image paths the same in both versions
- Update `aboutme.md` and other pages in the `vi/` directory
- Vietnamese UI text is already configured in `_data/ui-text.yml`

Happy translating! 🎉
