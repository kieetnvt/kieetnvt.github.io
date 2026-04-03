---
layout: post
title: Hướng Dẫn Sử Dụng Awesome Copilot
subtitle: Kho tài nguyên cộng đồng cho GitHub Copilot với 271+ Skills có sẵn
cover-img: /assets/img/vscode.png
thumbnail-img: /assets/img/vscode.png
share-img: /assets/img/vscode.png
tags: [vscode, copilot, ai, productivity, vietnamese]
author: kieetnvt
---

**Awesome Copilot** là kho tài nguyên cộng đồng khổng lồ với hơn 270+ skills, instructions và agents có sẵn để nâng cấp GitHub Copilot của bạn. Thay vì tự tạo từ đầu, bạn có thể tải xuống và sử dụng ngay các customizations đã được kiểm chứng!

## Awesome Copilot là gì?

[Awesome Copilot](https://awesome-copilot.github.com/) là dự án cộng đồng do GitHub duy trì, chứa các tài nguyên do 325+ contributors đóng góp từ khắp nơi trên thế giới.

**Nội dung kho tài nguyên:**

| Loại | Số lượng | Mô tả |
|------|----------|-------|
| 🎯 **Skills** | 271+ | Các khả năng chuyên biệt với instructions và tài nguyên đi kèm |
| 📋 **Instructions** | Nhiều | Chuẩn code áp dụng tự động theo file pattern |
| 🤖 **Agents** | Nhiều | Các agent Copilot chuyên biệt tích hợp MCP servers |
| 🔌 **Plugins** | Nhiều | Gói tổng hợp skills/instructions cho workflow cụ thể |
| 🪝 **Hooks** | Nhiều | Hành động tự động trong phiên agent |
| ⚡ **Workflows** | Nhiều | GitHub Actions automation bằng AI |

**Website:** [awesome-copilot.github.com](https://awesome-copilot.github.com/)
**GitHub:** [github.com/github/awesome-copilot](https://github.com/github/awesome-copilot)

## Cách Sử Dụng Awesome Copilot

### Phương Án 1: Cài Plugins (Dễ Nhất!)

Plugins là các gói tổng hợp nhiều skills/instructions với nhau:

```bash
# Cài plugin trực tiếp qua Copilot CLI
copilot plugin install <plugin-name>@awesome-copilot

# Ví dụ:
copilot plugin install azure@awesome-copilot
copilot plugin install testing@awesome-copilot
copilot plugin install react@awesome-copilot
```

**Kiểm tra plugins đã cài:**

```bash
copilot plugin list
```

### Phương Án 2: Tải Individual Skills

**Các bước:**

1. **Browse website:** Vào [awesome-copilot.github.com/skills](https://awesome-copilot.github.com/skills/)
2. **Tìm kiếm:** Dùng search bar tìm skill cần (ví dụ: "testing", "azure", "react")
3. **Tải xuống:** Click "Download" hoặc "GitHub"
4. **Copy vào project:**

```bash
# Cấu trúc thư mục
.agents/skills/
  └── skill-name/
      └── SKILL.md
```

**Skills phổ biến nên thử:**

```
🎲 roll-dice - Tung xúc xắc (skill đơn giản để làm quen)
🧪 webapp-testing - Test ứng dụng web với Playwright
☁️ azure-pricing - Ước tính chi phí Azure
✅ git-commit - Tạo commit messages thông minh
🔒 security-review - Quét lỗ hổng bảo mật trong code
🛠️ mcp-cli - Giao tiếp với MCP servers
📝 readme-blueprint-generator - Tự động tạo README.md
🐛 github-issues - Quản lý GitHub issues
```

### Phương Án 3: Sử Dụng Instructions

Copy instructions để định nghĩa chuẩn dự án:

**1. Browse Instructions:**

Vào [awesome-copilot.github.com/instructions](https://awesome-copilot.github.com/instructions/)

**2. Copy vào project:**

```bash
# Cho toàn project
.github/copilot-instructions.md

# Hoặc file-specific
.github/instructions/
  ├── react.instructions.md
  ├── testing.instructions.md
  └── api.instructions.md
```

### Phương Án 4: Sử Dụng Agents

Agents là các Copilot đặc biệt hóa tích hợp với MCP servers:

1. Browse [awesome-copilot.github.com/agents](https://awesome-copilot.github.com/agents/)
2. Tải agent file (`.agent.md`)
3. Copy vào `.agents/` folder
4. Sử dụng trong Copilot Chat

## Ví Dụ Thực Tế

### Ví Dụ 1: Thêm Testing Skills

**Tải skill webapp-testing:**

```bash
# Tạo thư mục cho skill
mkdir -p .agents/skills/webapp-testing

# Tải SKILL.md từ GitHub
# https://github.com/github/awesome-copilot/tree/main/skills/webapp-testing
```

**Sử dụng:**

```
Bạn: "Giúp tôi test trang đăng nhập"
→ Copilot tự động load webapp-testing skill!
→ Tạo test cases với Playwright
```

### Ví Dụ 2: Setup Azure Project

**Cài Azure plugin:**

```bash
copilot plugin install azure@awesome-copilot
```

**Lợi ích:**

- ✅ Skills cho Azure deployment
- ✅ Instructions cho Bicep best practices
- ✅ Agents cho resource management
- ✅ Cost optimization guidance

**Sử dụng:**

```
Bạn: "Deploy ứng dụng lên Azure"
→ Copilot dùng azure skills tự động
→ Tạo Bicep files đúng chuẩn
→ Kiểm tra cost optimization
```

### Ví Dụ 3: Code Security Review

**Tải security-review skill:**

```bash
mkdir -p .agents/skills/security-review
# Copy SKILL.md từ GitHub
```

**Sử dụng:**

```
Bạn: "Scan code tìm lỗ hổng bảo mật"
→ Copilot chạy security review
→ Tìm SQL injection, XSS, exposed secrets
→ Đề xuất fixes cụ thể
```

### Ví Dụ 4: Smart Git Commits

**Tải git-commit skill:**

Skill này tự động:
- Phân tích git diff
- Tạo conventional commit message
- Stage files thông minh
- Group changes hợp lý

**Sử dụng:**

```
Bạn: "/commit"
→ Copilot phân tích changes
→ Tạo message: "feat(auth): add OAuth2 login flow"
→ Commit với proper formatting
```

## Workflow Thực Tế

### Bước 1: Cài Plugins Cơ Bản

```bash
# Essential plugins
copilot plugin install github-actions@awesome-copilot
copilot plugin install testing@awesome-copilot

# Technology-specific
copilot plugin install azure@awesome-copilot        # Nếu dùng Azure
copilot plugin install react@awesome-copilot        # Nếu dùng React
copilot plugin install python@awesome-copilot       # Nếu dùng Python
```

### Bước 2: Thêm Skills Cho Tech Stack

**Ví dụ với React + TypeScript + Azure:**

```bash
.agents/skills/
  ├── webapp-testing/          # Test web apps
  ├── typescript-mcp-server-generator/  # Create MCP servers
  ├── azure-deployment-preflight/       # Validate Azure deploys
  └── security-review/         # Security scanning
```

### Bước 3: Setup Instructions

```markdown
# .github/copilot-instructions.md

# Project: E-commerce Platform

## Tech Stack
- Frontend: React 18 + TypeScript
- Backend: Node.js + Express
- Database: PostgreSQL
- Cloud: Azure
- Testing: Vitest + Playwright

## Code Standards
- Use TypeScript strict mode
- Follow Airbnb style guide
- 80% test coverage minimum
- All PRs must pass security scan

## Azure Resources
- Always use Bicep (not ARM templates)
- Use managed identities
- Tag resources: environment, project, owner
- Store secrets in Key Vault
```

### Bước 4: Test & Refine

```bash
# Kiểm tra skills đã load
/skills

# Kiểm tra instructions active
/instructions

# Test với prompt
"Create a login component with OAuth"
→ Xem Copilot có dùng đúng skills không
```

## Skills Nên Thử Ngay

### Cho Beginners

1. **roll-dice** - Đơn giản, dễ hiểu cách skills hoạt động
2. **github-copilot-starter** - Setup full Copilot config
3. **readme-blueprint-generator** - Auto-generate README
4. **conventional-commit** - Commit messages chuẩn
5. **create-agentsmd** - Tạo AGENTS.md file

### Cho Development

1. **webapp-testing** - Test automation với Playwright
2. **security-review** - Scan vulnerabilities
3. **git-commit** - Smart conventional commits
4. **codeql** - Setup CodeQL scanning
5. **dependabot** - Manage dependencies

### Cho Azure/Cloud

1. **azure-architecture-autopilot** - Design Azure infrastructure
2. **azure-pricing** - Cost estimation
3. **azure-deployment-preflight** - Validate deployments
4. **terraform-azurerm-set-diff-analyzer** - Terraform planning
5. **import-infrastructure-as-code** - Import existing resources

### Cho AI/ML Development

1. **arize-instrumentation** - LLM tracing
2. **phoenix-tracing** - AI observability
3. **agent-governance** - AI safety controls
4. **agentic-eval** - Evaluate AI outputs
5. **eval-driven-dev** - QA for LLM apps

## Tìm Skills Phù Hợp

### Dùng Website Search

```
1. Vào awesome-copilot.github.com
2. Gõ từ khóa trong search bar
3. Filter theo category
4. Click để xem chi tiết
```

**Từ khóa phổ biến:**

- `testing` - Test automation skills
- `azure` - Azure cloud skills
- `security` - Security scanning
- `git` - Git workflow skills
- `react` - React development
- `api` - API development
- `database` - Database skills
- `documentation` - Doc generation

### LLMs.txt File

Website cung cấp [llms.txt](https://awesome-copilot.github.com/llms.txt) - machine-readable listing của tất cả resources!

## Quản Lý Skills

### Kiểm Tra Skills Đang Hoạt Động

```bash
# Trong Copilot CLI
/skills                    # List all loaded skills
/instructions              # List all instructions
copilot plugin list        # List installed plugins
```

### Xóa Skills Không Dùng

```bash
# Xóa plugin
copilot plugin uninstall <plugin-name>@awesome-copilot

# Xóa skill
rm -rf .agents/skills/skill-name/
```

### Update Skills

Skills là community-maintained, nên check updates thường xuyên:

```bash
# Pull latest từ GitHub
cd /path/to/awesome-copilot-clone
git pull origin main

# Copy updated skills vào project
```

## Tips & Best Practices

### ✅ NÊN:

1. **Review trước khi dùng:**
   ```bash
   # Luôn đọc SKILL.md để hiểu skill làm gì
   cat .agents/skills/skill-name/SKILL.md
   ```

2. **Bắt đầu nhỏ:**
   - Thử 1-2 skills đơn giản trước (như roll-dice)
   - Hiểu cách hoạt động
   - Từ từ thêm skills phức tạp hơn

3. **Customize cho project:**
   ```markdown
   # Edit SKILL.md để phù hợp với needs
   ---
   name: webapp-testing
   description: Test web apps following OUR standards
   ---

   # Add project-specific test patterns
   ```

4. **Chia sẻ với team:**
   ```bash
   # Commit skills vào Git
   git add .agents/skills/
   git commit -m "Add webapp-testing skill"
   git push
   ```

5. **Document việc sử dụng:**
   ```markdown
   # README.md

   ## AI Development Setup

   We use these Awesome Copilot skills:
   - webapp-testing: E2E tests với Playwright
   - security-review: Security scanning
   - git-commit: Conventional commits

   Install: `copilot plugin install testing@awesome-copilot`
   ```

### ❌ KHÔNG NÊN:

1. **Cài tất cả skills:**
   - Skills tốn context window
   - Chỉ cài những gì cần thiết

2. **Dùng mà không review:**
   - Skills là third-party code
   - Luôn audit trước khi dùng production

3. **Quên update:**
   - Skills được improve liên tục
   - Check updates định kỳ

4. **Ignore security:**
   - Một số skills run terminal commands
   - Review command trước khi approve

## Đóng Góp Cho Awesome Copilot

Awesome Copilot là open source - bạn có thể contribute!

### Cách Đóng Góp

1. **Fork repository:**
   ```bash
   # https://github.com/github/awesome-copilot
   ```

2. **Tạo skill mới:**
   ```bash
   mkdir -p skills/my-skill
   touch skills/my-skill/SKILL.md
   ```

3. **Follow template:**
   ```markdown
   ---
   name: my-skill
   description: What this skill does and when to use it
   ---

   # Detailed instructions
   # Examples
   # References
   ```

4. **Submit PR:**
   - Follow [CONTRIBUTING.md](https://github.com/github/awesome-copilot/blob/main/CONTRIBUTING.md)
   - Include tests
   - Add documentation

## Resources & Links

### Official Links

- 🌐 **Website:** [awesome-copilot.github.com](https://awesome-copilot.github.com/)
- 💻 **GitHub:** [github.com/github/awesome-copilot](https://github.com/github/awesome-copilot)
- 📖 **Learning Hub:** [awesome-copilot.github.com/learning-hub](https://awesome-copilot.github.com/learning-hub/)
- 🛠️ **Tools:** [awesome-copilot.github.com/tools](https://awesome-copilot.github.com/tools/)

### Skill Collections

- **Skills:** [awesome-copilot.github.com/skills](https://awesome-copilot.github.com/skills/) (271+)
- **Instructions:** [awesome-copilot.github.com/instructions](https://awesome-copilot.github.com/instructions/)
- **Agents:** [awesome-copilot.github.com/agents](https://awesome-copilot.github.com/agents/)
- **Plugins:** [awesome-copilot.github.com/plugins](https://awesome-copilot.github.com/plugins/)
- **Workflows:** [awesome-copilot.github.com/workflows](https://awesome-copilot.github.com/workflows/)

### Related Posts

- [VSCode Agent Skills Guide](./2026-04-03-vscode-agent-skills-guide-vi.md)
- [VSCode Custom Instructions Guide](./2026-04-03-vscode-custom-instructions-guide-vi.md)

## Quick Start Checklist

- [ ] Browse [awesome-copilot.github.com](https://awesome-copilot.github.com/)
- [ ] Cài 1-2 plugins cơ bản (`testing`, `github-actions`)
- [ ] Tải 2-3 skills phù hợp với tech stack
- [ ] Test skills bằng simple prompts
- [ ] Setup instructions cho project standards
- [ ] Document setup trong README
- [ ] Share với team qua Git

## Kết Luận

**Awesome Copilot** là kho báu với 270+ skills và resources được community kiểm chứng. Thay vì tự tạo từ đầu, bạn có thể:

✅ Cài plugins trong vài giây
✅ Tải skills có sẵn và customize
✅ Học từ examples của 325+ contributors
✅ Tiết kiệm hàng giờ setup time
✅ Improve Copilot experience ngay lập tức

Bắt đầu với một vài skills đơn giản, hiểu cách chúng hoạt động, rồi từ từ mở rộng. Happy coding! 🚀

---

**Fun fact:** Roll a dice để test skill đầu tiên! 🎲
```
"Roll a d20"
```
