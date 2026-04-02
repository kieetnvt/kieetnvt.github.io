# URL Issue Fixed! ✅

## Problem
When accessing `http://localhost:4000/2026-04-02-six-react-hooks-deep-dive/`, the Vietnamese version was displaying instead of English.

## Root Causes

1. **Date Mismatch**: 
   - English post: `2026-04-01-six-react-hooks-deep-dive.md`
   - Vietnamese post was: `2026-04-02-six-react-hooks-deep-dive.md`

2. **URL Conflict**:
   - Vietnamese posts in `vi/_posts/` generated to same URLs as English posts
   - No `/vi/` prefix in Vietnamese post URLs

3. **Missing Language Identifiers**:
   - English post lacked `lang: en` field
   - Missing `ref` field to link translations

## Fixes Applied

### 1. Updated English Post Front Matter
```yaml
---
layout: post
title: "Six Hooks That Will Change How You Write React"
subtitle: "A practical, beginner-friendly deep-dive..."
lang: en                        # Added
ref: six-react-hooks-deep-dive  # Added
---
```

### 2. Fixed Vietnamese Post Date
- Renamed: `vi/_posts/2026-04-02-...` → `vi/_posts/2026-04-01-...`
- Now matches English post date

### 3. Updated _config.yml
Added permalink prefix for Vietnamese posts:
```yaml
-
  scope:
    path: "vi/_posts"
    type: "posts"
  values:
    lang: "vi"
    permalink: /vi/:year-:month-:day-:title/  # Added
```

### 4. Improved Language Switcher
Now uses `ref` field to automatically find and link translations:
```liquid
{% if page.ref %}
  {% assign posts=site.posts | where:"ref", page.ref %}
  <!-- Links posts by ref field -->
{% endif %}
```

## Result

### URLs Now Work Correctly

✅ **English**: http://localhost:4000/2026-04-01-six-react-hooks-deep-dive/
✅ **Vietnamese**: http://localhost:4000/vi/2026-04-01-six-react-hooks-deep-dive/

### Language Switcher Works
- English post shows: 🇬🇧 EN | 🇻🇳 VI (clickable)
- Vietnamese post shows: 🇬🇧 EN (clickable) | 🇻🇳 VI
- Automatically links between versions using `ref` field

## Testing

```bash
# Rebuild and serve
bundle exec jekyll serve

# Test URLs:
# English:    http://localhost:4000/2026-04-01-six-react-hooks-deep-dive/
# Vietnamese: http://localhost:4000/vi/2026-04-01-six-react-hooks-deep-dive/
```

## For Future Posts

### English Post Template
```yaml
---
layout: post
title: "Your English Title"
subtitle: "Your subtitle"
tags: [tag1, tag2]
author: kieetnvt
lang: en
ref: unique-post-slug
---
```

### Vietnamese Post Template
```yaml
---
layout: post
title: "Tiêu đề tiếng Việt"
subtitle: "Phụ đề"
tags: [tag1, tag2]
author: kieetnvt
lang: vi
ref: unique-post-slug  # Same as English version!
---
```

### Key Rules
1. **Same `ref` value** for linked translations
2. **Same date** in filenames (YYYY-MM-DD)
3. Vietnamese posts automatically get `/vi/` prefix
4. Language switcher works automatically via `ref` field

## Summary

All Vietnamese posts now properly appear under `/vi/` URLs and won't conflict with English posts. The language switcher automatically finds and links translation pairs using the `ref` field.

✅ Issue resolved!
✅ Both versions working correctly
✅ Language switching functional
✅ No more URL conflicts

---

*Fixed: April 2, 2026*
