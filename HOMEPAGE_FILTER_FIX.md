# Homepage Language Filter Fix ✅

## Problem
The homepage at `http://localhost:4000/` was showing both English and Vietnamese posts mixed together.

## Solution
Updated `_layouts/home.html` to filter posts by language before displaying them.

## Changes Made

### Modified: `_layouts/home.html`

**Before:**
```liquid
{% assign posts = paginator.posts | default: site.posts %}
```

**After:**
```liquid
{% assign all_posts = paginator.posts | default: site.posts %}

<!-- Filter posts by language -->
{% assign posts = "" | split: "" %}
{% for post in all_posts %}
  {% if page.lang == "vi" %}
    {% if post.lang == "vi" %}
      {% assign posts = posts | push: post %}
    {% endif %}
  {% else %}
    {% if post.lang == "en" or post.lang == nil or post.lang == "" %}
      {% assign posts = posts | push: post %}
    {% endif %}
  {% endif %}
{% endfor %}
```

## How It Works

### English Homepage (`/`)
- Checks: `page.lang != "vi"`
- Shows: Posts with `lang: en` OR posts with no `lang` field (backwards compatibility)
- Hides: Posts with `lang: vi`

### Vietnamese Homepage (`/vi/`)
- Checks: `page.lang == "vi"`
- Shows: Posts with `lang: vi`
- Hides: All other posts

## Result

✅ **English homepage**: http://localhost:4000/
- Shows only English posts
- Maintains backwards compatibility with old posts (no lang field)

✅ **Vietnamese homepage**: http://localhost:4000/vi/
- Shows only Vietnamese posts
- Completely separate from English listing

## Testing

```bash
# Rebuild and serve
bundle exec jekyll serve

# Visit both homepages:
# http://localhost:4000/     → English posts only
# http://localhost:4000/vi/  → Vietnamese posts only
```

## Summary

Now your blog properly separates content by language:
- English readers see only English content at `/`
- Vietnamese readers see only Vietnamese content at `/vi/`
- Each language has its own complete blog experience
- No more mixed language listings!

---

*Fixed: April 2, 2026*
