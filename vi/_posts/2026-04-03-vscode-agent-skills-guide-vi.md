---
layout: post
title: Hướng Dẫn Sử Dụng VSCode Agent Skills
subtitle: Hướng dẫn đơn giản để tùy chỉnh GitHub Copilot với Agent Skills
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/vscode-copilot.png
share-img: /assets/img/path.jpg
tags: [vscode, copilot, ai, productivity, vietnamese]
author: kieetnvt
---

Agent Skills trong VSCode cho phép bạn dạy GitHub Copilot các khả năng chuyên biệt và quy trình làm việc. Khác với custom instructions chỉ định nghĩa chuẩn code, skills cho phép tạo ra các khả năng phức tạp, có thể tái sử dụng bao gồm scripts, ví dụ và tài nguyên.

## Agent Skills là gì?

Agent Skills là các thư mục chứa file `SKILL.md` định nghĩa các tác vụ chuyên biệt cho GitHub Copilot. Chúng tuân theo [chuẩn mở](https://agentskills.io/) hoạt động trên nhiều AI agent khác nhau bao gồm:

- GitHub Copilot trong VS Code
- GitHub Copilot CLI
- GitHub Copilot coding agent

**Lợi ích chính:**
- 🎯 Chuyên biệt hóa Copilot cho các tác vụ cụ thể
- 🔄 Tạo một lần, sử dụng tự động trong mọi cuộc trò chuyện
- 🧩 Kết hợp nhiều skills để xây dựng quy trình phức tạp
- ⚡ Chỉ tải nội dung liên quan khi cần thiết

## Agent Skills vs Custom Instructions

| Tính năng | Agent Skills | Custom Instructions |
|-----------|-------------|-------------------|
| **Mục đích** | Dạy các khả năng và quy trình chuyên biệt | Định nghĩa chuẩn và hướng dẫn code |
| **Tính di động** | Hoạt động trên nhiều công cụ | Chỉ VS Code và GitHub.com |
| **Nội dung** | Instructions, scripts, ví dụ, tài nguyên | Chỉ instructions |
| **Phạm vi** | Theo tác vụ, tải khi cần | Luôn được áp dụng |

## Hướng Dẫn Nhanh: Skill Đầu Tiên Trong 5 Phút

Hãy cùng tạo một skill đơn giản dạy Copilot cách tung xúc xắc. Ví dụ thực tế này cho thấy việc tạo skill hoạt động dễ dàng như thế nào.

### Tạo File Skill

Tạo file `.agents/skills/roll-dice/SKILL.md` trong project của bạn:

```markdown
---
name: roll-dice
description: Tung xúc xắc sử dụng bộ tạo số ngẫu nhiên. Dùng khi được yêu cầu tung xúc xắc (d6, d20, v.v.), tung xúc xắc, hoặc tạo kết quả tung xúc xắc ngẫu nhiên.
---

Để tung xúc xắc, sử dụng lệnh sau để tạo số ngẫu nhiên từ 1
đến số mặt cho trước:

echo $((RANDOM % <sides> + 1))

Get-Random -Minimum 1 -Maximum (<sides> + 1)

Thay `<sides>` bằng số mặt của xúc xắc (ví dụ: 6 cho xúc xắc thông thường, 20 cho d20).
```

Vậy là xong! Chỉ **một file, dưới 20 dòng**. Đây là chức năng của từng phần:

- **name** — Định danh ngắn cho skill (phải khớp với tên thư mục)
- **description** — Cho agent biết khi nào dùng skill này (rất quan trọng!)
- **body** — Hướng dẫn mà agent tuân theo khi được kích hoạt

### Thử Ngay

1. Mở project của bạn trong VS Code
2. Mở Copilot Chat panel
3. Chọn **Agent mode** từ dropdown mode
4. Gõ `/skills` để xác nhận `roll-dice` xuất hiện trong danh sách
5. Hỏi: **"Tung xúc xắc d20"** hoặc **"Roll a d20"**

Copilot sẽ kích hoạt skill, chạy lệnh terminal (sau khi xin phép), và trả về một số ngẫu nhiên từ 1 đến 20! 🎲

### Cách Hoạt Động (Bên Trong)

1. **Khám phá** — Agent quét `.agents/skills/` và chỉ đọc `name` và `description`
2. **Kích hoạt** — Khi bạn hỏi về tung xúc xắc, agent khớp câu hỏi với description và tải toàn bộ SKILL.md
3. **Thực thi** — Agent tuân theo hướng dẫn, điều chỉnh lệnh theo yêu cầu cụ thể của bạn

**Progressive disclosure** này cho phép agent truy cập nhiều skills mà không cần tải tất cả hướng dẫn ngay từ đầu!

## Các Bước Đơn Giản Để Sử Dụng Agent Skills

### Bước 1: Tạo Skill Đầu Tiên

Cách dễ nhất là dùng AI để tạo skill:

1. Mở Chat view trong VSCode
2. Gõ `/create-skill` trong chat
3. Mô tả những gì bạn muốn (ví dụ: "skill để debug integration tests")
4. Trả lời các câu hỏi làm rõ
5. Copilot tạo file `SKILL.md` với cấu trúc hoàn chỉnh

**Tạo thủ công:**

1. Mở Chat Customizations (click biểu tượng bánh răng trong Chat view)
2. Chọn tab **Skills**
3. Chọn **New Skill (Workspace)** hoặc **New Skill (User)**
4. Nhập tên cho skill của bạn
5. Hoàn thiện file `SKILL.md`

### Bước 2: Hiểu Định Dạng SKILL.md

File skill có hai phần: **YAML frontmatter** (header) và **hướng dẫn** (body).

```markdown
---
name: webapp-testing
description: Giúp test ứng dụng web với best practices và templates
argument-hint: [test file] [options]
user-invocable: true
---

# Web Application Testing Skill

## Skill này làm gì
Skill này giúp bạn viết và thực thi tests cho ứng dụng web theo best practices.

## Khi nào dùng
- Viết test cases mới
- Debug các tests bị lỗi
- Thiết lập cơ sở hạ tầng test

## Các bước thực hiện
1. Phân tích component cần test
2. Tạo test template từ [test-template.js](./test-template.js)
3. Điền các kịch bản test
4. Chạy tests và kiểm tra kết quả

## Ví dụ
Xem thư mục [examples/](./examples/) để tham khảo các test cases mẫu.
```

### Bước 3: Nơi Lưu Trữ Skills

**Project Skills** (chia sẻ với team):
- `.agents/skills/` (mặc định, được khuyến nghị)
- `.github/skills/`
- `.claude/skills/`

**Personal Skills** (chỉ cho bạn):
- `~/.agents/skills/` (mặc định)
- `~/.copilot/skills/`
- `~/.claude/skills/`

**Lưu ý:** VS Code tìm kiếm skills trong `.agents/skills/` theo mặc định. Bạn có thể cấu hình thêm các vị trí khác với setting `chat.skillsLocations`.

### Bước 4: Sử Dụng Skills

**Dùng như Slash Commands:**

Gõ `/` trong chat để xem tất cả skills có sẵn, sau đó chọn một:

```
/webapp-testing cho trang đăng nhập
/github-actions-debugging PR #42
```

**Tự động tải:**

Chỉ cần mô tả tác vụ của bạn một cách tự nhiên. Copilot sẽ tự động tải các skills liên quan:

```
"Giúp tôi test luồng xác thực"
→ Copilot tự động tải skill webapp-testing
```

### Bước 5: Điều Khiển Hành Vi Skill

Dùng các thuộc tính frontmatter để kiểm soát cách truy cập skills:

```yaml
---
name: my-skill
description: Skill tùy chỉnh của tôi
user-invocable: false        # Ẩn khỏi menu /, tự động tải
disable-model-invocation: true  # Chỉ có sẵn qua /command
---
```

## Ví Dụ: Web Testing Skill

Đây là ví dụ hoàn chỉnh về một skill thực tế:

```
.github/skills/webapp-testing/
├── SKILL.md                 # Hướng dẫn chính
├── test-template.js         # Template có thể tái sử dụng
└── examples/
    ├── login-test.js        # Ví dụ: test login flow
    └── api-test.js          # Ví dụ: API testing
```

## Dùng Skills Từ Cộng Đồng

Khám phá các skills có sẵn từ cộng đồng:

1. Duyệt repository [github/awesome-copilot](https://github.com/github/awesome-copilot)
2. Copy thư mục skill vào folder `.github/skills/` của bạn
3. Xem lại và tùy chỉnh theo nhu cầu
4. Bắt đầu sử dụng ngay!

**Mẹo:** Luôn kiểm tra bảo mật của shared skills trước khi dùng.

## Các Mẹo Nhanh

✅ **NÊN:**
- Viết mô tả rõ ràng, cụ thể để giúp Copilot chọn đúng skill
- Bao gồm ví dụ và templates trong thư mục skill
- Tham chiếu các files bổ sung dùng đường dẫn tương đối: `[template](./template.js)`
- Dùng tên có ý nghĩa (chữ thường với dấu gạch ngang)

❌ **KHÔNG NÊN:**
- Tạo skills quá rộng (hãy cụ thể)
- Quên tham chiếu files trong SKILL.md
- Dùng tên dài hơn 64 ký tự
- Bao gồm thông tin nhạy cảm trong skills

## Cách Copilot Sử Dụng Skills (Bên Trong)

Skills tải nội dung tuần tự:

1. **Khám phá:** Copilot đọc tên và mô tả skill
2. **Tải:** Khi khớp, tải các hướng dẫn từ SKILL.md
3. **Tài nguyên:** Truy cập các files bổ sung chỉ khi được tham chiếu

Điều này có nghĩa bạn có thể có nhiều skills mà không tốn context!

## Checklist Bắt Đầu Nhanh

- [ ] Mở Chat Customizations (biểu tượng bánh răng → tab Skills)
- [ ] Tạo skill đầu tiên với `/create-skill`
- [ ] Thêm mô tả cụ thể về khi nào dùng nó
- [ ] Test bằng cách gõ `/tên-skill` trong chat
- [ ] Tinh chỉnh dựa trên kết quả

## Tìm Hiểu Thêm

- [Hướng dẫn Quickstart Agent Skills](https://agentskills.io/skill-creation/quickstart) - Tutorial chính thức
- [Best Practices cho Agent Skills](https://agentskills.io/skill-creation/best-practices) - Cách viết skills hiệu quả
- [Tài liệu VS Code chính thức](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Đặc tả Agent Skills](https://agentskills.io/specification) - Tài liệu tham khảo định dạng đầy đủ
- [Repository ví dụ Skills](https://github.com/anthropics/skills) - Ví dụ thực tế
- [Awesome Copilot Repository](https://github.com/github/awesome-copilot) - Bộ sưu tập cộng đồng

---

Bắt đầu tạo Agent Skill đầu tiên của bạn ngay hôm nay và làm cho GitHub Copilot mạnh mẽ hơn cho các quy trình làm việc cụ thể của bạn! 🚀
