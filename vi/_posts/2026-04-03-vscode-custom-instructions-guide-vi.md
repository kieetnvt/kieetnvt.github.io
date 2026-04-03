---
layout: post
title: Hướng Dẫn Sử Dụng Custom Instructions Trong VSCode
subtitle: Cấu hình và sử dụng instructions/rules khi code với AI Agent
cover-img: /assets/img/vscode.png
thumbnail-img: /assets/img/vscode.png
share-img: /assets/img/vscode.png
tags: [vscode, copilot, ai, productivity, vietnamese]
author: kieetnvt
---

Custom Instructions trong VSCode cho phép bạn định nghĩa các hướng dẫn và quy tắc chung mà AI sẽ tự động tuân theo khi tạo code và xử lý các tác vụ phát triển. Thay vì phải nhắc đi nhắc lại trong mỗi lần chat, bạn chỉ cần thiết lập một lần và AI sẽ luôn nhớ!

## Custom Instructions là gì?

Custom Instructions là các file Markdown chứa hướng dẫn để AI hiểu rõ:
- 🎯 Chuẩn code và quy ước đặt tên của dự án
- 🏗️ Kiến trúc và patterns cần tuân theo
- 🔒 Yêu cầu bảo mật và xử lý lỗi
- 📚 Thư viện và công nghệ ưu tiên sử dụng
- ✍️ Chuẩn viết documentation

**Lợi ích:**
- ✅ Nhất quán trong toàn bộ dự án
- ⚡ Không cần lặp lại context mỗi lần chat
- 🤝 Chia sẻ chuẩn code với team
- 🎯 AI tạo code đúng với yêu cầu dự án ngay từ đầu

## 2 Loại Instructions Chính

### 1. Always-On Instructions (Luôn Áp Dụng)

Tự động được thêm vào **mọi chat request**. Dùng cho chuẩn code toàn dự án.

**Các file:**
- `.github/copilot-instructions.md` - Chuẩn chính thức
- `AGENTS.md` - Nếu dùng nhiều AI agents
- `CLAUDE.md` - Tương thích với Claude Code
- Organization-level instructions - Chia sẻ qua nhiều repos

### 2. File-Based Instructions (Áp Dụng Theo Điều Kiện)

Chỉ được áp dụng khi làm việc với **files cụ thể** hoặc **tác vụ tương ứng**.

**Các file:**
- `*.instructions.md` - Áp dụng theo glob pattern hoặc mô tả

## Hướng Dẫn Nhanh: Tạo Instructions Đầu Tiên

### Cách 1: Tạo Project-Wide Instructions (Khuyên Dùng!)

File này áp dụng cho toàn bộ dự án:

**1. Tạo file `.github/copilot-instructions.md`:**

```
mkdir -p .github
touch .github/copilot-instructions.md
```

**2. Thêm nội dung:**

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

**3. Thử ngay:**

Mở Chat trong VSCode và hỏi:
```
"Tạo một user profile component"
```

AI sẽ tự động tạo code theo đúng chuẩn bạn đã định nghĩa! 🎉

### Cách 2: Tạo File-Specific Instructions

Dùng khi cần quy tắc riêng cho từng loại file hoặc thư mục.

**1. Tạo file `.github/instructions/react.instructions.md`:**

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

**2. Tạo file `.github/instructions/testing.instructions.md`:**

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

### Cách 3: Dùng AI Để Tạo Instructions

**Siêu nhanh với AI:**

1. Gõ `/create-instruction` trong Chat
2. Mô tả quy tắc bạn muốn (ví dụ: "always use tabs and single quotes")
3. Trả lời các câu hỏi làm rõ
4. AI tạo file với đầy đủ frontmatter và nội dung!

**Hoặc tạo instructions toàn dự án:**

Gõ `/init` trong Chat - AI sẽ phân tích project và tạo instructions phù hợp!

## Vị Trí Lưu Trữ Instructions

### Project-Level (Chia sẻ với team)

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

### User-Level (Chỉ cho bạn)

```
~/.copilot/instructions/          # VSCode Copilot
~/.claude/rules/                  # Claude format
```

**Cấu hình tùy chỉnh:** Thêm vào `settings.json`:

```json
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "~/.copilot/instructions": true
  }
}
```

## Cách Sử Dụng Instructions

### 1. Tự Động (Automatic)

Instructions với `applyTo` được tự động áp dụng khi làm việc với file khớp pattern:

```yaml
---
applyTo: '**/*.tsx'
---
```

### 2. Thủ Công (Manual)

- Gõ `/instructions` trong Chat để xem danh sách
- Click để thêm vào chat request
- Hoặc dùng `#file:<path>` để reference file instructions

### 3. Kiểm Tra Instructions Đã Được Áp Dụng

Xem phần **References** trong chat response để biết instructions nào được dùng!

## Ví Dụ Thực Tế

### Ví Dụ 1: Backend API Standards

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

### Ví Dụ 2: Documentation Style

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

## Example Template
```markdown
# Project Name

Brief description of what this project does.

## Installation

\`\`\`bash
npm install project-name
\`\`\`

## Quick Start

\`\`\`typescript
import { feature } from 'project-name';

// Simple example
const result = feature({ option: 'value' });
\`\`\`

## API Reference

### `feature(options)`

Description of what this function does.

**Parameters:**
- `options` (object): Configuration options
  - `option` (string): What this option does

**Returns:** Description of return value

**Example:**
\`\`\`typescript
// Detailed example
\`\`\`
```
```

## Tips Viết Instructions Hiệu Quả

### ✅ NÊN:

1. **Ngắn gọn và rõ ràng:**
   ```markdown
   ❌ Tránh: "Developers should try to use functional programming concepts where it makes sense"
   ✅ Tốt: "Use Array.map(), .filter(), .reduce() instead of for loops"
   ```

2. **Giải thích lý do:**
   ```markdown
   Use `date-fns` instead of `moment.js` because moment.js is deprecated
   and adds 67KB to bundle size.
   ```

3. **Dùng ví dụ code cụ thể:**
   ```markdown
   ❌ Tránh: "Use proper error handling"
   ✅ Tốt:
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

4. **Tập trung vào điều đặc biệt:**
   - Không cần viết những gì linter đã check
   - Chỉ viết quy tắc riêng của dự án

5. **Tổ chức theo chủ đề:**
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

### ❌ KHÔNG NÊN:

- Viết quá dài dòng
- Quy tắc mơ hồ, không cụ thể
- Lặp lại những gì đã có trong standard linter
- Quá nhiều exceptions và special cases

## Ưu Tiên Khi Có Nhiều Instructions

Khi có nhiều instructions cùng lúc, thứ tự ưu tiên:

1. **Personal instructions** (user-level) - Ưu tiên cao nhất
2. **Repository instructions** (project-level)
3. **Organization instructions** - Ưu tiên thấp nhất

Tất cả đều được thêm vào context, nhưng khi xung đột thì theo thứ tự trên.

## Chia Sẻ Instructions Với Team

### Trong Git Repository

Commit các instructions vào repo:

```bash
git add .github/copilot-instructions.md
git add .github/instructions/
git commit -m "Add coding standards for AI"
git push
```

Team members sẽ tự động nhận được khi pull code!

### Organization-Level Instructions

Cho các công ty/tổ chức lớn với nhiều repos:

1. Admin GitHub Organization tạo instructions
2. Enable trong VS Code settings:
   ```json
   {
     "github.copilot.chat.organizationInstructions.enabled": true
   }
   ```
3. Instructions tự động áp dụng cho tất cả repos trong organization!

## Xử Lý Sự Cố

### Instructions không được áp dụng?

**Checklist:**

1. ✅ File đúng vị trí? (`.github/copilot-instructions.md` cho always-on)
2. ✅ `applyTo` pattern khớp với file đang làm việc?
3. ✅ Settings đã enable? (`chat.includeApplyingInstructions`)
4. ✅ Kiểm tra **References** trong chat response

**Debug tool:**

1. Mở Command Palette (Cmd/Ctrl + Shift + P)
2. Chọn `Chat: Configure Instructions`
3. Hover qua file để xem source location
4. Hoặc click chuột phải trong Chat view → **Diagnostics**

### Kiểm tra instructions nào đang active?

```
Gõ `/instructions` trong Chat → Xem danh sách đầy đủ
```

## Sử Dụng AGENTS.md Cho Multi-Agent

Nếu bạn dùng nhiều AI agents (Copilot, Claude, v.v.), dùng `AGENTS.md`:

```markdown
# AGENTS.md

This project uses:
- React 18 with TypeScript
- Zustand for state management
- React Query for data fetching
- Tailwind CSS for styling

Follow the coding standards in .github/copilot-instructions.md
```

Enable trong settings:

```json
{
  "chat.useAgentsMdFile": true
}
```

## Tích Hợp Với Claude Code

Dùng `CLAUDE.md` để tương thích:

**Vị trí:**
- Workspace root: `CLAUDE.md`
- Trong thư mục: `.claude/CLAUDE.md`
- User home: `~/.claude/CLAUDE.md`
- Local only: `CLAUDE.local.md` (không commit vào git)

Enable:
```json
{
  "chat.useClaudeMdFile": true
}
```

## Sync Instructions Giữa Các Máy

Dùng Settings Sync của VS Code:

1. Enable Settings Sync trong VS Code
2. Command Palette → `Settings Sync: Configure`
3. Chọn **Prompts and Instructions**
4. User instructions sẽ sync tự động!

## Quick Start Checklist

- [ ] Tạo `.github/copilot-instructions.md` với project standards
- [ ] Thêm ví dụ code cụ thể vào instructions
- [ ] Test bằng cách chat với Copilot
- [ ] Kiểm tra References trong response
- [ ] Tạo file-specific instructions nếu cần (`.instructions.md`)
- [ ] Commit vào Git để chia sẻ với team
- [ ] Document instructions trong README

## Tài Nguyên Tham Khảo

- [Tài liệu VS Code chính thức](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Awesome Copilot - Community Examples](https://github.com/github/awesome-copilot)
- [GitHub Organization Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-organization-instructions)
- [Agent Skills Guide](https://agentskills.io/)

---

Bắt đầu tạo custom instructions ngay hôm nay để AI coding assistant hiểu dự án của bạn tốt hơn và tạo code chuẩn hơn! 🚀
