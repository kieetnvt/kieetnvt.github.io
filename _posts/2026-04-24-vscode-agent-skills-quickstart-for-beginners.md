---
layout: post
title: VSCode Agent Skills Quickstart for Beginners
subtitle: Setup and coding guide to build your first practical skill
cover-img: /assets/img/vscode.png
thumbnail-img: /assets/img/vscode.png
share-img: /assets/img/vscode.png
tags: [vscode, copilot, ai, productivity, agent-skills]
author: kieetnvt
---

Agent Skills let you teach GitHub Copilot repeatable workflows. If custom instructions are your rules, skills are your tools.

This guide is for beginners who want to go from zero setup to a working skill in VS Code.

## Why Agent Skills?

Agent Skills are useful when you do the same kind of work repeatedly:

- Generate test scaffolding
- Debug logs with a fixed checklist
- Create release notes from commit history
- Validate a pull request against team rules

Instead of rewriting the same prompts, you package the workflow once and reuse it.

## Prerequisites

- VS Code
- GitHub Copilot extension
- Copilot Chat in Agent mode

Agent Skills are an open format, so the same skill can also work in compatible agents outside VS Code.

## Step 1: Create the Skill Folder

From your project root, create:

~~~
.agents/skills/roll-dice/SKILL.md
~~~

A skill is just a folder that contains `SKILL.md`.

## Step 2: Write Your First SKILL.md

Put this into `SKILL.md`:

~~~markdown
---
name: roll-dice
description: Roll dice using a random number generator. Use when asked to roll a die (d6, d20, etc.), roll dice, or generate a random dice roll.
---

To roll a die, run one command and return only the resulting number.

Bash:
echo $((RANDOM % <sides> + 1))

PowerShell:
Get-Random -Minimum 1 -Maximum (<sides> + 1)

Replace <sides> with the requested die size.
~~~

### What each part means

- `name`: Skill identifier. Keep it short and match the folder name.
- `description`: Activation hint. The model uses this to decide when to load your skill.
- Body: Exact instructions to execute after activation.

## Step 3: Verify Discovery in VS Code

1. Open Copilot Chat.
2. Select Agent mode.
3. Type `/skills`.
4. Confirm `roll-dice` appears.

If it does not appear, check the file path and the YAML frontmatter format.

## Step 4: Run a Real Prompt

Ask:

~~~
Roll a d20
~~~

The agent should activate your skill and ask permission to run a terminal command.

Expected result: one number between 1 and 20.

## How Skill Loading Works

Agent Skills use progressive loading:

1. Discovery: read `name` and `description` only.
2. Activation: load full `SKILL.md` when user intent matches.
3. Execution: follow the instructions in the body.

This keeps context light while still allowing many skills in one workspace.

## Build Your First Useful Skill (Next Step)

After `roll-dice`, create one skill tied to your real workflow.

Example: `jekyll-post-starter`

Purpose:
- Create a new Jekyll post with frontmatter from your blog format
- Generate both English and Vietnamese post skeletons
- Suggest tags and slug

If your daily workflow includes content writing, this saves time immediately.

## Common Newbie Mistakes

- Description is too generic, so activation is inconsistent
- Name and folder do not match
- Invalid YAML frontmatter
- Skill instructions are vague, causing non-deterministic outputs
- Too much scope in one skill

## Quick Checklist

- [ ] Skill file is at `.agents/skills/<name>/SKILL.md`
- [ ] `name` matches folder name
- [ ] `description` includes realistic trigger phrases
- [ ] Instructions are explicit and testable
- [ ] `/skills` shows your skill
- [ ] At least 5 real prompts tested

## Final Advice

Start small, test often, then evolve.

A good first week goal:
- 1 tiny skill that always works
- 1 workflow skill that saves you 10+ minutes a day

That is enough to feel the value of Agent Skills in real coding work.
