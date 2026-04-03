---
layout: post
title: Getting Started with VSCode Agent Skills
subtitle: Simple guide to customize GitHub Copilot with Agent Skills
cover-img: /assets/img/vscode.png
thumbnail-img: /assets/img/vscode.png
share-img: /assets/img/vscode.png
tags: [vscode, copilot, ai, productivity]
author: kieetnvt
---

Agent Skills in VSCode allow you to teach GitHub Copilot specialized capabilities and workflows. Unlike custom instructions that define coding standards, skills enable more complex, reusable capabilities that can include scripts, examples, and resources.

## What are Agent Skills?

Agent Skills are folders containing a `SKILL.md` file that defines specialized tasks for GitHub Copilot. They follow an [open standard](https://agentskills.io/) that works across multiple AI agents including:

- GitHub Copilot in VS Code
- GitHub Copilot CLI
- GitHub Copilot coding agent

**Key Benefits:**
- 🎯 Specialize Copilot for domain-specific tasks
- 🔄 Create once, use automatically across all conversations
- 🧩 Combine multiple skills to build complex workflows
- ⚡ Only relevant content loads into context when needed

## Agent Skills vs Custom Instructions

| Feature | Agent Skills | Custom Instructions |
|---------|-------------|-------------------|
| **Purpose** | Teach specialized capabilities and workflows | Define coding standards and guidelines |
| **Portability** | Works across multiple tools | VS Code and GitHub.com only |
| **Content** | Instructions, scripts, examples, resources | Instructions only |
| **Scope** | Task-specific, loaded on-demand | Always applied |

## Quick Tutorial: Your First Skill in 5 Minutes

Let's create a simple skill that teaches Copilot to roll dice. This practical example shows how easy it is to create a working skill.

### Create the Skill File

Create `.agents/skills/roll-dice/SKILL.md` in your project:

```markdown
---
name: roll-dice
description: Roll dice using a random number generator. Use when asked to roll a die (d6, d20, etc.), roll dice, or generate a random dice roll.
---

To roll a die, use the following command that generates a random number from 1
to the given number of sides:
echo ((RANDOM % <sides> + 1))
Get-Random -Minimum 1 -Maximum (<sides> + 1)

Replace `<sides>` with the number of sides on the die (e.g., 6 for a standard
die, 20 for a d20).
```

That's it! Just **one file, under 20 lines**. Here's what each part does:

- **name** — Short identifier for the skill (must match folder name)
- **description** — Tells the agent when to use this skill (this is crucial!)
- **body** — Instructions the agent follows when activated

### Try It Out

1. Open your project in VS Code
2. Open the Copilot Chat panel
3. Select **Agent mode** from the mode dropdown
4. Type `/skills` to confirm `roll-dice` appears in the list
5. Ask: **"Roll a d20"**

Copilot should activate the skill, run the terminal command (after asking permission), and return a random number between 1 and 20! 🎲

### How It Works (Behind the Scenes)

1. **Discovery** — Agent scans `.agents/skills/` and reads only the `name` and `description`
2. **Activation** — When you ask about rolling dice, agent matches your question to the description and loads the full SKILL.md
3. **Execution** — Agent follows instructions, adapting the command to your specific request

This **progressive disclosure** lets the agent access many skills without loading all instructions upfront!

## Simple Steps to Use Agent Skills

### Step 1: Create Your First Skill

The easiest way is to use AI to generate a skill:

1. Open the Chat view in VSCode
2. Type `/create-skill` in the chat
3. Describe what you want (e.g., "a skill for debugging integration tests")
4. Answer any clarifying questions
5. Copilot generates a `SKILL.md` file with complete structure

**Manual Creation:**

1. Open Chat Customizations (click gear icon in Chat view)
2. Select the **Skills** tab
3. Choose **New Skill (Workspace)** or **New Skill (User)**
4. Enter a name for your skill
5. Complete the `SKILL.md` file

### Step 2: Understanding SKILL.md Format

A skill file has two parts: **YAML frontmatter** (header) and **instructions** (body).

```markdown
---
name: webapp-testing
description: Helps test web applications with best practices and templates
argument-hint: [test file] [options]
user-invocable: true
---

# Web Application Testing Skill

## What this skill does
This skill helps you write and execute web application tests following best practices.

## When to use
- Writing new test cases
- Debugging failing tests
- Setting up test infrastructure

## Steps to follow
1. Analyze the component to test
2. Generate test template from [test-template.js](./test-template.js)
3. Fill in test scenarios
4. Run tests and verify results

## Examples
See [examples/](./examples/) folder for reference test cases.
```

### Step 3: Where to Store Skills

**Project Skills** (shared with team):
- `.agents/skills/` (default, recommended)
- `.github/skills/`
- `.claude/skills/`

**Personal Skills** (just for you):
- `~/.agents/skills/` (default)
- `~/.copilot/skills/`
- `~/.claude/skills/`

**Note:** VS Code looks for skills in `.agents/skills/` by default. You can configure additional locations with the `chat.skillsLocations` setting.

### Step 4: Using Skills

**As Slash Commands:**

Type `/` in chat to see all available skills, then select one:

```
/webapp-testing for the login page
/github-actions-debugging PR #42
```

**Automatic Loading:**

Just describe your task naturally. Copilot will automatically load relevant skills:

```
"Help me test the authentication flow"
→ Copilot automatically loads the webapp-testing skill
```

### Step 5: Control Skill Behavior

Use frontmatter properties to control how skills are accessed:

```yaml
---
name: my-skill
description: My custom skill
user-invocable: false        # Hide from / menu, load automatically
disable-model-invocation: true  # Only available via /command
---
```

## Example: Web Testing Skill

Here's a complete example of a practical skill:

```
.github/skills/webapp-testing/
├── SKILL.md                 # Main instructions
├── test-template.js         # Reusable template
└── examples/
    ├── login-test.js        # Example: login flow
    └── api-test.js          # Example: API testing
```

## Use Community Skills

Discover ready-made skills from the community:

1. Browse [github/awesome-copilot](https://github.com/github/awesome-copilot) repository
2. Copy the skill directory to your `.github/skills/` folder
3. Review and customize for your needs
4. Start using immediately!

**Pro Tip:** Always review shared skills for security before using them.

## Quick Tips

✅ **DO:**
- Write clear, specific descriptions to help Copilot choose the right skill
- Include examples and templates in your skill directory
- Reference additional files using relative paths: `[template](./template.js)`
- Use meaningful names (lowercase with hyphens)

❌ **DON'T:**
- Create overly broad skills (be specific)
- Forget to reference files in SKILL.md
- Use names longer than 64 characters
- Include sensitive information in skills

## How Copilot Uses Skills (Behind the Scenes)

Skills load content progressively:

1. **Discovery:** Copilot reads skill name and description
2. **Loading:** When matched, loads SKILL.md instructions
3. **Resources:** Accesses additional files only when referenced

This means you can have many skills without consuming context!

## Quick Start Checklist

- [ ] Open Chat Customizations (gear icon → Skills tab)
- [ ] Create your first skill with `/create-skill`
- [ ] Add specific description of when to use it
- [ ] Test by typing `/your-skill-name` in chat
- [ ] Refine based on results

## Learn More

- [Agent Skills Quickstart](https://agentskills.io/skill-creation/quickstart) - Official quickstart tutorial
- [Agent Skills Best Practices](https://agentskills.io/skill-creation/best-practices) - How to write effective skills
- [Official VS Code Documentation](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Agent Skills Specification](https://agentskills.io/specification) - Complete format reference
- [Example Skills Repository](https://github.com/anthropics/skills) - Real-world examples
- [Awesome Copilot Repository](https://github.com/github/awesome-copilot) - Community collection

---

Start creating your first Agent Skill today and make GitHub Copilot even more powerful for your specific workflows! 🚀
