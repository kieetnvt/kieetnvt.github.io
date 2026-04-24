---
layout: post
title: Hướng Dẫn Nhanh VSCode Agent Skills Cho Người Mới
subtitle: Hướng dẫn setup và coding để tạo skill đầu tiên trong VS Code
cover-img: /assets/img/vscode.png
thumbnail-img: /assets/img/vscode.png
share-img: /assets/img/vscode.png
tags: [vscode, copilot, ai, productivity, agent-skills, vietnamese]
author: kieetnvt
lang: vi
ref: vscode-agent-skills-quickstart-for-beginners
---

Agent Skills giúp bạn dạy GitHub Copilot các workflow có thể tái sử dụng. Nếu custom instructions là bộ quy tắc, thì skills là bộ công cụ.

Bài viết này dành cho người mới, đi từ setup cơ bản đến một skill đầu tiên chạy được trong VS Code.

## Vì sao nên dùng Agent Skills?

Agent Skills hữu ích khi bạn lặp đi lặp lại một loại công việc:

- Tạo khung test nhanh
- Debug log theo checklist có sẵn
- Tạo release note từ lịch sử commit
- Kiểm tra pull request theo quy ước team

Thay vì viết lại prompt mỗi lần, bạn đóng gói workflow một lần và dùng lại.

## Điều kiện cần

- VS Code
- GitHub Copilot extension
- Copilot Chat ở Agent mode

Agent Skills là định dạng mở, nên cùng một skill có thể dùng được với các agent tương thích ngoài VS Code.

## Bước 1: Tạo thư mục skill

Từ root project, tạo:

~~~
.agents/skills/roll-dice/SKILL.md
~~~

Một skill đơn giản là một thư mục có file `SKILL.md`.

## Bước 2: Viết SKILL.md đầu tiên

Đặt nội dung sau vào `SKILL.md`:

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

### Ý nghĩa từng phần

- `name`: Định danh skill. Nên ngắn gọn và trùng tên thư mục.
- `description`: Tín hiệu kích hoạt. Model dựa vào đây để quyết định có nạp skill hay không.
- Body: Hướng dẫn cụ thể cần thực thi sau khi kích hoạt.

## Bước 3: Kiểm tra VS Code đã nhận skill

1. Mở Copilot Chat.
2. Chọn Agent mode.
3. Gõ `/skills`.
4. Xác nhận `roll-dice` xuất hiện.

Nếu không thấy, kiểm tra lại đường dẫn file và định dạng YAML frontmatter.

## Bước 4: Chạy prompt thực tế

Hỏi:

~~~
Roll a d20
~~~

Agent sẽ kích hoạt skill và có thể hỏi quyền chạy lệnh terminal.

Kết quả mong đợi: một số trong khoảng từ 1 đến 20.

## Skill được nạp như thế nào

Agent Skills dùng cơ chế nạp theo giai đoạn:

1. Discovery: chỉ đọc `name` và `description`.
2. Activation: nạp toàn bộ `SKILL.md` khi câu hỏi khớp ý định.
3. Execution: làm theo hướng dẫn trong body.

Cách này giúp tiết kiệm context nhưng vẫn cho phép có nhiều skills trong một workspace.

## Bước tiếp theo: Tạo skill có giá trị thực tế

Sau `roll-dice`, hãy tạo một skill gắn với workflow hằng ngày của bạn.

Ví dụ: `jekyll-post-starter`

Mục tiêu:
- Tạo bài viết Jekyll mới theo đúng frontmatter của blog
- Tạo khung bài viết tiếng Anh và tiếng Việt
- Gợi ý tags và slug

Nếu bạn viết nội dung thường xuyên, skill này giúp tiết kiệm thời gian ngay lập tức.

## Lỗi người mới hay gặp

- Description quá chung chung, kích hoạt không ổn định
- Tên skill và tên thư mục không trùng nhau
- YAML frontmatter sai định dạng
- Hướng dẫn mơ hồ, kết quả không nhất quán
- Nhồi quá nhiều mục tiêu vào một skill

## Checklist nhanh

- [ ] File nằm đúng đường dẫn `.agents/skills/<name>/SKILL.md`
- [ ] `name` trùng với tên thư mục
- [ ] `description` có trigger phrase sát thực tế
- [ ] Hướng dẫn rõ ràng, có thể test
- [ ] `/skills` hiển thị đúng skill
- [ ] Đã test tối thiểu 5 prompt thực tế

## Lời khuyên cuối

Bắt đầu nhỏ, test thường xuyên, sau đó mở rộng dần.

Mục tiêu 1 tuần đầu:
- 1 skill nhỏ chạy ổn định
- 1 skill workflow giúp tiết kiệm ít nhất 10 phút mỗi ngày

Chỉ vậy là đủ để cảm nhận rõ giá trị của Agent Skills trong công việc coding hằng ngày.
