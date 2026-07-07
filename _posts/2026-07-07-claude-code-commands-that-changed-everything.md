---
layout: post
title: I Wasted 6 Months Using Claude Code Wrong
subtitle: The commands that made Claude Code feel like a real development environment
cover-img: /assets/img/codebg.webp
thumbnail-img: /assets/img/codebg.webp
share-img: /assets/img/codebg.webp
tags: [claude-code, ai, productivity, developer-tools]
author: kieetnvt
---

It was 2 AM on a Tuesday, and I was three hours into a debugging session that should have taken 30 minutes.

My Claude Code window was a sprawling mess. The conversation was long, the context window was packed, responses were getting slower, and I was copy-pasting code between tabs instead of actually building.

Then a senior developer friend casually asked:

> Have you tried `/compact`?

I had not.

He typed one command. The session condensed into a clean summary, the important decisions stayed intact, and we kept working without losing the thread.

That was the moment I realized I had been using Claude Code like a chat box instead of a development environment.

This is the short guide I wish I had read earlier.

## First: Check Your Version

Claude Code changes quickly, so command availability depends on your version, plan, and environment.

Before memorizing any command list, run:

~~~bash
claude --version
~~~

Then inside Claude Code, type:

~~~
/help
~~~

or just type `/` to see the commands available in your current session.

The official references are also worth bookmarking:

- [Claude Code commands reference](https://code.claude.com/docs/en/commands)
- [Claude Code interactive mode reference](https://code.claude.com/docs/en/interactive-mode)

## 1. `/init`: Create Project Memory Once

Every new project starts with the same friction: explaining the tech stack, folder structure, coding style, dependencies, and common commands.

`/init` helps by generating a starter `CLAUDE.md` for the project.

Instead of manually writing the same context again and again, run:

~~~
/init
~~~

Claude reads the repository and creates a project guide it can reuse in future sessions.

What this usually saves:

- Repeating setup instructions
- Explaining project architecture every time
- Reminding Claude about test and build commands
- Restating code style preferences

Treat `CLAUDE.md` like living documentation. Review it, edit it, and keep only the instructions that are actually useful.

## 2. `/memory`: Edit What Claude Remembers

After a few projects, you start repeating personal preferences:

- Prefer tests first
- Keep changes surgical
- Avoid unnecessary abstractions
- Explain non-obvious logic with short comments
- Do not use `any` in TypeScript without a reason

`/memory` opens the memory files Claude Code uses for persistent instructions.

~~~
/memory
~~~

Use it for durable preferences, not temporary task details. If the instruction only matters for the current bug, keep it in the current conversation. If it should affect future work across projects, memory may be the right place.

## 3. GitHub PR Comments: Ask Claude Directly

Older Claude Code versions had `/pr-comments`, but the current commands reference marks it as removed. The current workflow is simpler: ask Claude directly to inspect pull request comments.

For example:

~~~
Check the comments on the current pull request and summarize what needs to change.
~~~

or:

~~~
Read PR #42 comments and help me address them.
~~~

This avoids switching between GitHub and Claude Code while still keeping the discussion grounded in review feedback. You will usually need the `gh` CLI authenticated for GitHub-related workflows.

## 4. `/btw`: Ask a Side Question Without Polluting Context

Sometimes you are deep in a task and a side question appears:

- What was the name of that config file?
- Why are we using JWT instead of session cookies?
- What did we decide earlier about retries?

If you ask normally, that tangent becomes part of the main conversation. `/btw` keeps it separate.

~~~
/btw what was the config file Claude edited earlier?
~~~

The side question can use current conversation context, but it does not become part of the main history. It is useful for quick answers that should not derail the task.

## 5. `/compact`: Recover From Long Sessions

Long sessions get noisy. You accumulate logs, failed attempts, partial ideas, and old context that no longer matters.

`/compact` summarizes the conversation so far and frees context.

~~~
/compact
~~~

You can also give it focus instructions:

~~~
/compact keep the implementation decisions, failing tests, and remaining TODOs
~~~

Use this when:

- The session is getting slow
- The conversation has too many dead ends
- You are switching from investigation to implementation
- You want to continue tomorrow without dragging the entire transcript along

## 6. `!`: Run Shell Commands Without Leaving Claude Code

Shell mode lets you run commands directly from the Claude Code prompt by starting with `!`.

~~~bash
! npm test
! git status
! ls -la
~~~

The command output is added to the session, so Claude can respond to it.

This is especially useful for tight feedback loops:

~~~bash
! npm install
! npm run test
! git diff
~~~

Instead of copying terminal output back into chat, keep the command and result inside the same workflow.

## 7. `/context`: See What Is Filling the Window

When a session feels heavy, guessing is not enough. `/context` shows what is consuming the context window.

~~~
/context
~~~

Use it before compacting if you want to understand whether the issue is:

- Long pasted logs
- Repeated file reads
- Tool output
- Memory bloat
- A conversation that has simply gone on too long

This makes context management concrete instead of mysterious.

## The Workflow That Finally Clicked

My Claude Code workflow now looks more like this:

1. Run `/init` in a new project.
2. Keep durable preferences in `/memory`.
3. Use `!` for quick terminal checks.
4. Use `/btw` for side questions.
5. Use `/context` when the session feels heavy.
6. Use `/compact` before the conversation becomes a mess.
7. Ask Claude directly for PR review comments instead of relying on removed command names.

The difference is not one magical command. It is learning that Claude Code has workflow primitives, not just a prompt box.

## Final Advice

Do not memorize every command.

Start with the few that remove daily friction:

- `/init`
- `/memory`
- `/btw`
- `/compact`
- `/context`
- `!`

Then type `/` inside Claude Code whenever you wonder what else is available. The command menu is the fastest way to discover features that match your current version and environment.
