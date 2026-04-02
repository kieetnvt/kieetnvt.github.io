# Quick Start Guide: Vietnamese Blog Translation

## 🚀 Your Blog is Now Bilingual!

### What's Ready
- ✅ **48 Vietnamese post templates** in `vi/_posts/`
- ✅ **Vietnamese homepage** at `/vi/`
- ✅ **Language switcher** on every post
- ✅ **All configurations** complete

### Start Translating in 3 Steps

#### Step 1: Pick a Post
```bash
cd vi/_posts/
ls  # See all posts ready for translation
```

#### Step 2: Translate
Open any file and translate:
- Title
- Subtitle
- Content
- Tags (optional)

Keep the front matter structure and `lang: vi` field!

#### Step 3: Test
```bash
bundle exec jekyll serve
```
Visit: http://localhost:4000/vi/

### Translation Priority

**Start with these popular posts:**
1. `2026-04-02-six-react-hooks-deep-dive.md` ✅ (Already done as example!)
2. `2024-10-22-a-beginners-guide-to-docker-image-for-developers.md`
3. `2024-11-02-securing-node-js-in-production.md`
4. `2025-05-08-postgresql-crucial-best-practices.md`
5. `2024-10-28-react-app-in-docker.md`

### Translation Template

Every Vietnamese post should look like:

```markdown
---
layout: post
title: "[Vietnamese Title]"
subtitle: "[Vietnamese Subtitle]"
cover-img: /assets/img/[same-as-english].png
tags: [tag1, tag2]
author: kieetnvt
lang: vi
ref: [original-post-slug]
---

[Vietnamese content here]
```

### URLs After Translation

**English:** `https://yoursite.com/2024-10-22-docker-guide/`
**Vietnamese:** `https://yoursite.com/vi/2024-10-22-docker-guide/`

### Testing Checklist

Before committing translations:
- [ ] Title and subtitle translated
- [ ] Content fully translated
- [ ] Code examples kept in English (standard practice)
- [ ] Technical terms appropriately handled
- [ ] Images display correctly
- [ ] Language switcher works
- [ ] No broken links

### Tips for Good Translations

1. **Technical Terms**: Keep in English when commonly used
   - Example: "Docker container" not "Docker thùng chứa"

2. **Code Blocks**: Keep code in original English
   - Only translate comments if necessary

3. **Tone**: Match the friendly tone of the English version

4. **Cultural Context**: Adapt examples for Vietnamese readers when appropriate

### Deploy to GitHub Pages

```bash
git add .
git commit -m "Add Vietnamese translations"
git push origin main
```

GitHub Pages will automatically build and deploy both languages!

### Need Help?

- Full details: `MULTILINGUAL_README.md`
- Setup info: `SETUP_COMPLETE.md`
- Example: `vi/_posts/2026-04-02-six-react-hooks-deep-dive.md`

---

**Happy translating! 🇻🇳✨**
