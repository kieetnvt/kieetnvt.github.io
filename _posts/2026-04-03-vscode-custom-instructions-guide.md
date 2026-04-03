---
layout: post
title: Complete Guide to VSCode Custom Instructions
subtitle: Configure and use instructions/rules for AI Agent Coding
cover-img: /assets/img/vscode.png
thumbnail-img: /assets/img/vscode.png
share-img: /assets/img/vscode.png
tags: [vscode, copilot, ai, productivity]
author: kieetnvt
---

Custom Instructions in VSCode allow you to define common guidelines and rules that AI automatically follows when generating code and handling development tasks. Instead of repeating context in every chat, set it once and AI remembers!

## What are Custom Instructions?

Custom Instructions are Markdown files containing guidance for AI to understand:
- 🎯 Code standards and naming conventions
- 🏗️ Architecture and patterns to follow
- 🔒 Security requirements and error handling
- 📚 Preferred libraries and technologies
- ✍️ Documentation standards

**Benefits:**
- ✅ Consistency across entire project
- ⚡ No need to repeat context in every chat
- 🤝 Share coding standards with team
- 🎯 AI generates correct code from the start

## 2 Main Types of Instructions

### 1. Always-On Instructions

Automatically added to **every chat request**. Use for project-wide standards.

**Files:**
- `.github/copilot-instructions.md` - Official standard
- `AGENTS.md` - If using multiple AI agents
- `CLAUDE.md` - Compatible with Claude Code
- Organization-level instructions - Share across repos

### 2. File-Based Instructions

Only applied when working with **specific files** or **matching tasks**.

**Files:**
- `*.instructions.md` - Apply via glob pattern or description

## Quick Guide: Create Your First Instructions

### Method 1: Create Project-Wide Instructions (Recommended!)

This file applies to the entire project:

**1. Create `.github/copilot-instructions.md`:**

```bash
mkdir -p .github
touch .github/copilot-instructions.md
```

**2. Add content:**

```markdown
# Coding Standards

## Technology Stack
- Framework: React 18 with TypeScript
- State Management: Zustand (not Redux)
- Styling: Tailwind CSS
- Testing: Vitest + React Testing Library

## Code Style
- Use functional components with hooks
- Prefer named exports over default exports
- Use arrow functions for all function declarations
- Always add TypeScript types for props and return values

## Naming Conventions
- Components: PascalCase (e.g., UserProfile.tsx)
- Hooks: camelCase with 'use' prefix (e.g., useAuth.ts)
- Utils: camelCase (e.g., formatDate.ts)
- Constants: UPPER_SNAKE_CASE

## Architecture
- Keep components under 200 lines
- Extract business logic into custom hooks
- Use composition over inheritance
- One component per file

## Error Handling
- Always wrap async operations in try-catch
- Use error boundaries for component errors
- Log errors to monitoring service
- Show user-friendly error messages

## Documentation
- Add JSDoc comments for complex functions
- Include usage examples in README
- Document all environment variables
```

**3. Try it now:**

Open Chat in VSCode and ask:
```
"Create a user profile component"
```

AI will automatically generate code following your defined standards! 🎉

### Method 2: Create File-Specific Instructions

Use when you need different rules for different file types or folders.

**1. Create `.github/instructions/react.instructions.md`:**

```markdown
---
name: 'React Components'
description: 'Coding standards for React components'
applyTo: 'src/components/**/*.tsx'
---

# React Component Guidelines

## Component Structure
Always follow this order:
1. Imports (React, third-party, local)
2. Types/Interfaces
3. Component function
4. Styled components (if any)
5. Default export

## Hooks Order
1. State hooks (useState)
2. Context hooks (useContext)
3. Ref hooks (useRef)
4. Effect hooks (useEffect)
5. Custom hooks

## Example
```tsx
import React, { useState, useEffect } from 'react';
import { Button } from '@/components/ui';
import { useAuth } from '@/hooks/useAuth';

interface UserCardProps {
  userId: string;
  onUpdate?: () => void;
}

export function UserCard({ userId, onUpdate }: UserCardProps) {
  const [user, setUser] = useState<User | null>(null);
  const { isAuthenticated } = useAuth();

  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);

  return (
    <div className="p-4 border rounded">
      {/* component content */}
    </div>
  );
}
```
```

**2. Create `.github/instructions/testing.instructions.md`:**

```markdown
---
name: 'Testing Standards'
description: 'Guidelines for writing tests'
applyTo: '**/*.test.{ts,tsx}'
---

# Testing Guidelines

## Test Structure
- Use `describe` for grouping related tests
- Use `it` or `test` for individual test cases
- Follow AAA pattern: Arrange, Act, Assert

## React Testing
- Prefer `screen.getByRole` over other queries
- Test user behavior, not implementation
- Mock external dependencies
- Use `userEvent` over `fireEvent`

## Example
```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { LoginForm } from './LoginForm';

describe('LoginForm', () => {
  it('should submit form with valid credentials', async () => {
    // Arrange
    const handleSubmit = vi.fn();
    render(<LoginForm onSubmit={handleSubmit} />);

    // Act
    await userEvent.type(screen.getByLabelText(/email/i), 'test@example.com');
    await userEvent.type(screen.getByLabelText(/password/i), 'password123');
    await userEvent.click(screen.getByRole('button', { name: /login/i }));

    // Assert
    expect(handleSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123'
    });
  });
});
```
```

### Method 3: Use AI to Generate Instructions

**Super fast with AI:**

1. Type `/create-instruction` in Chat
2. Describe the rule you want (e.g., "always use tabs and single quotes")
3. Answer clarifying questions
4. AI creates file with complete frontmatter and content!

**Or generate project-wide instructions:**

Type `/init` in Chat - AI will analyze your project and create appropriate instructions!

## Instructions Storage Locations

### Project-Level (Share with team)

```
.github/
  ├── copilot-instructions.md     # Always-on
  └── instructions/               # File-based
      ├── react.instructions.md
      ├── api.instructions.md
      └── testing.instructions.md

AGENTS.md                         # Always-on (multi-agent)
CLAUDE.md                         # Always-on (Claude compatible)
```

### User-Level (Personal)

```
~/.copilot/instructions/          # VSCode Copilot
~/.claude/rules/                  # Claude format
```

**Custom configuration:** Add to `settings.json`:

```json
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "~/.copilot/instructions": true
  }
}
```

## How to Use Instructions

### 1. Automatic

Instructions with `applyTo` are automatically applied when working with matching files:

```yaml
---
applyTo: '**/*.tsx'
---
```

### 2. Manual

- Type `/instructions` in Chat to see the list
- Click to add to chat request
- Or use `#file:<path>` to reference instruction files

### 3. Check Applied Instructions

See the **References** section in chat response to know which instructions were used!

## Real-World Examples

### Example 1: Backend API Standards

`.github/instructions/api.instructions.md`:

```markdown
---
name: 'API Design'
description: 'RESTful API standards for backend services'
applyTo: 'src/api/**/*.ts'
---

# API Development Guidelines

## Endpoint Structure
- Use plural nouns: `/api/users`, `/api/products`
- Use HTTP methods correctly: GET (read), POST (create), PUT (update), DELETE (delete)
- Version APIs: `/api/v1/users`

## Response Format
```typescript
// Success response
{
  "success": true,
  "data": { /* actual data */ },
  "message": "Operation successful"
}

// Error response
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message"
  }
}
```

## Error Codes
- 400: Bad Request (validation errors)
- 401: Unauthorized (authentication required)
- 403: Forbidden (insufficient permissions)
- 404: Not Found (resource doesn't exist)
- 500: Internal Server Error (server issues)

## Security
- Always validate and sanitize input
- Use parameterized queries to prevent SQL injection
- Implement rate limiting
- Log all API requests with user context
```

### Example 2: Documentation Style

`.github/instructions/docs.instructions.md`:

```markdown
---
name: 'Documentation Style'
description: 'Writing style for README and documentation files'
applyTo: '**/{README,CONTRIBUTING,CHANGELOG}.md'
---

# Documentation Writing Guidelines

## Structure
1. Hero section with project name and description
2. Quick start / Installation
3. Usage examples
4. API reference (if applicable)
5. Contributing guidelines
6. License

## Writing Style
- Use active voice
- Keep sentences short and clear
- Include code examples for all features
- Add screenshots for UI components
- Use emoji sparingly for visual hierarchy

## Code Examples
- Always include complete, runnable examples
- Show both basic and advanced usage
- Include comments explaining non-obvious parts
- Use TypeScript types in examples
```

## Tips for Writing Effective Instructions

### ✅ DO:

1. **Be concise and clear:**
   ```markdown
   ❌ Avoid: "Developers should try to use functional programming concepts where it makes sense"
   ✅ Better: "Use Array.map(), .filter(), .reduce() instead of for loops"
   ```

2. **Explain the reasoning:**
   ```markdown
   Use `date-fns` instead of `moment.js` because moment.js is deprecated
   and adds 67KB to bundle size.
   ```

3. **Use concrete code examples:**
   ```markdown
   ❌ Avoid: "Use proper error handling"
   ✅ Better:
   ```typescript
   // Always wrap async operations
   try {
     const data = await fetchUser(id);
     return data;
   } catch (error) {
     logger.error('Failed to fetch user', { id, error });
     throw new UserFetchError(id, error);
   }
   ```
   ```

4. **Focus on non-obvious rules:**
   - Skip what linters already check
   - Only write project-specific rules

5. **Organize by topic:**
   ```
   .github/instructions/
   ├── frontend/
   │   ├── react.instructions.md
   │   └── styling.instructions.md
   ├── backend/
   │   ├── api.instructions.md
   │   └── database.instructions.md
   └── testing/
       └── e2e.instructions.md
   ```

### ❌ DON'T:

- Write too verbosely
- Use vague, non-specific rules
- Repeat what standard linters already enforce
- Have too many exceptions and special cases

## Priority When Multiple Instructions Exist

When multiple instructions exist, priority order:

1. **Personal instructions** (user-level) - Highest priority
2. **Repository instructions** (project-level)
3. **Organization instructions** - Lowest priority

All are added to context, but conflicts follow this order.

## Share Instructions With Team

### In Git Repository

Commit instructions to repo:

```bash
git add .github/copilot-instructions.md
git add .github/instructions/
git commit -m "Add coding standards for AI"
git push
```

Team members automatically get them when pulling code!

### Organization-Level Instructions

For large companies/organizations with many repos:

1. GitHub Organization admin creates instructions
2. Enable in VS Code settings:
   ```json
   {
     "github.copilot.chat.organizationInstructions.enabled": true
   }
   ```
3. Instructions automatically apply to all repos in organization!

## Troubleshooting

### Instructions not being applied?

**Checklist:**

1. ✅ File in correct location? (`.github/copilot-instructions.md` for always-on)
2. ✅ `applyTo` pattern matches working file?
3. ✅ Settings enabled? (`chat.includeApplyingInstructions`)
4. ✅ Check **References** in chat response

**Debug tool:**

1. Open Command Palette (Cmd/Ctrl + Shift + P)
2. Select `Chat: Configure Instructions`
3. Hover over file to see source location
4. Or right-click in Chat view → **Diagnostics**

### Check which instructions are active?

```
Type `/instructions` in Chat → See complete list
```

## Use AGENTS.md for Multi-Agent

If you use multiple AI agents (Copilot, Claude, etc.), use `AGENTS.md`:

```markdown
# AGENTS.md

This project uses:
- React 18 with TypeScript
- Zustand for state management
- React Query for data fetching
- Tailwind CSS for styling

Follow the coding standards in .github/copilot-instructions.md
```

Enable in settings:

```json
{
  "chat.useAgentsMdFile": true
}
```

## Integration With Claude Code

Use `CLAUDE.md` for compatibility:

**Locations:**
- Workspace root: `CLAUDE.md`
- In folder: `.claude/CLAUDE.md`
- User home: `~/.claude/CLAUDE.md`
- Local only: `CLAUDE.local.md` (not committed to git)

Enable:
```json
{
  "chat.useClaudeMdFile": true
}
```

## Sync Instructions Across Machines

Use VS Code Settings Sync:

1. Enable Settings Sync in VS Code
2. Command Palette → `Settings Sync: Configure`
3. Select **Prompts and Instructions**
4. User instructions will sync automatically!

## Quick Start Checklist

- [ ] Create `.github/copilot-instructions.md` with project standards
- [ ] Add concrete code examples to instructions
- [ ] Test by chatting with Copilot
- [ ] Check References in response
- [ ] Create file-specific instructions if needed (`.instructions.md`)
- [ ] Commit to Git to share with team
- [ ] Document instructions in README

## Resources

- [Official VS Code Documentation](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Awesome Copilot - Community Examples](https://github.com/github/awesome-copilot)
- [GitHub Organization Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-organization-instructions)
- [Agent Skills Guide](https://agentskills.io/)

---

Start creating custom instructions today to make your AI coding assistant understand your project better and generate more accurate code! 🚀
