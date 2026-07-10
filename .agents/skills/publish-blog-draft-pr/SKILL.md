---
name: publish-blog-draft-pr
description: Use when the user provides a URL, Markdown draft, HTML document, Medium/Freedium export, or attached article and asks to create Jekyll blog posts in this repo, especially English plus Vietnamese companion posts, branch isolation, commit, push, or PR creation.
---

# Publish Blog Draft PR

## Overview

Convert a provided article source into this repository's blog format, create the English post and Vietnamese companion, verify the Jekyll site builds, then isolate the work on a branch and open a pull request when requested.

Keep changes surgical: only the post files and explicitly requested assets should change.

## Inputs

Accept any of these source forms:

- A local Markdown file path
- A local HTML file path
- A URL to an article or source page
- Pasted Markdown or HTML content
- An attached draft file

If the source is a URL, browse or fetch it only when needed and cite official/current sources for claims that are likely stale. For imported Medium/Freedium-style drafts, remove metadata and promotional content that does not belong on this blog.

## Repository Conventions

Use these post locations:

- English: `_posts/YYYY-MM-DD-slug.md`
- Vietnamese: `vi/_posts/YYYY-MM-DD-slug-vi.md`

Use frontmatter matching existing posts:

```yaml
---
layout: post
title: Title Case English Title
subtitle: Short practical subtitle
cover-img: /assets/img/<existing-image>
thumbnail-img: /assets/img/<existing-image>
share-img: /assets/img/<existing-image>
tags: [tag-one, tag-two, tag-three]
author: kieetnvt
---
```

For Vietnamese companion posts, add:

```yaml
lang: vi
ref: slug-without-date-or-vi
```

Also add `vietnamese` to Vietnamese tags.

Choose the date in this order:

1. Source `published` date if present.
2. Source article date if clearly stated.
3. Current date if no publication date exists.

Create slugs in lowercase kebab-case. Remove emojis, punctuation, and filler words only when needed for readability.

## Content Cleanup

Before creating posts:

- Remove source-only metadata such as `free`, `freedium_url`, `source_url`, and imported publication notes.
- Remove subscription prompts, clap/follow requests, coffee links, and unrelated "read more" lists unless the user explicitly wants them.
- Remove external `<picture>` or Medium image markup unless the image is intentionally being added to repo assets.
- Replace imported image references with an appropriate existing image from `assets/img`.
- Preserve useful links in normal Markdown.
- Convert fenced code blocks to `~~~language` when it avoids Liquid/Jekyll conflicts.
- Fix obviously wrong code fence languages from imports.
- Avoid publishing unverified performance numbers as facts; phrase them as examples to benchmark locally unless verified.
- Keep the article practical and readable rather than a raw import.

## Workflow

1. Inspect current git state with `git status --short --branch`.
2. If on a branch that already backs another PR, switch to `master` before starting new work.
3. Create a separate branch from `master` with a name like `add-<topic>-post`.
4. Read the source draft completely. If it is truncated or incomplete, say so and create a coherent post only from available material.
5. Inspect nearby reference posts for frontmatter and style when needed.
6. Create the English post.
7. Create the Vietnamese companion post with matching `ref`.
8. Run a Jekyll build using the project's RVM environment:

```bash
GEM_HOME=/Users/kietnguyen/.rvm/gems/ruby-2.5.3 GEM_PATH=/Users/kietnguyen/.rvm/gems/ruby-2.5.3:/Users/kietnguyen/.rvm/rubies/ruby-2.5.3/lib/ruby/gems/2.5.0 PATH=/Users/kietnguyen/.rvm/gems/ruby-2.5.3/bin:/Users/kietnguyen/.rvm/rubies/ruby-2.5.3/bin:/usr/bin:/bin:/usr/sbin:/sbin /Users/kietnguyen/.rvm/rubies/ruby-2.5.3/bin/bundle exec jekyll build
```

9. Confirm generated `_site` paths for both posts.
10. Stage only the intended files.
11. Commit with a clear subject and body.
12. Push the branch.
13. Create a PR against `master` with summary, notes, and verification.
14. Finish with PR URL, branch, commit hash, included files, and build result.

## Branch and PR Rules

- Do not mix unrelated post work into an existing PR branch.
- If the user asks to "do the same", infer separate branch, commit, push, and PR unless they say otherwise.
- Use one branch and one PR per source article by default.
- Do not stage `_site` output unless the repo explicitly tracks it for the requested change.
- Do not delete or rewrite user files outside the repo. A draft in `Downloads` is a source, not a file to modify.

## Commit and PR Template

Commit subject:

```text
Add <topic> blog post
```

Commit body:

```text
Add an English post about <topic>.

Add the Vietnamese companion post with localized frontmatter and matching ref slug.
```

PR body:

```markdown
## Summary
- Add an English blog post about <topic>
- Add the Vietnamese companion post with localized frontmatter and matching ref slug
- Use the existing <image> asset for cover, thumbnail, and sharing

## Notes
- Cleaned imported draft content by removing external image markup, promotional metadata, or stale claims when applicable

## Verification
- Ran Jekyll build with the project RVM Ruby environment: exit 0
- Build still reports pre-existing Liquid warnings in older React posts, if they appear
```

## Common Mistakes

- Publishing raw Medium frontmatter instead of Jekyll frontmatter.
- Forgetting `lang: vi` and `ref` in the Vietnamese post.
- Reusing the source title with emojis or clickbait that does not fit the blog.
- Keeping broken imported `<picture>` tags.
- Staging unrelated files from another branch.
- Claiming a build passed without running it fresh.
- Creating the post on `master` after the user asked for a PR.
