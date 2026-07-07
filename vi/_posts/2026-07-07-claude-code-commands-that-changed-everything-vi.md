---
layout: post
title: Tôi Đã Dùng Claude Code Sai Cách Suốt 6 Tháng
subtitle: Những command giúp Claude Code giống một môi trường phát triển thật sự hơn
cover-img: /assets/img/codebg.webp
thumbnail-img: /assets/img/codebg.webp
share-img: /assets/img/codebg.webp
tags: [claude-code, ai, productivity, developer-tools, vietnamese]
author: kieetnvt
lang: vi
ref: claude-code-commands-that-changed-everything
---

Đó là 2 giờ sáng một ngày thứ Ba, và tôi đã mất ba tiếng để debug một vấn đề đáng lẽ chỉ cần khoảng 30 phút.

Cửa sổ Claude Code của tôi lúc đó là một mớ hỗn độn. Conversation quá dài, context window gần đầy, response chậm dần, còn tôi thì copy-paste code qua lại giữa nhiều tab thay vì thật sự tập trung xây dựng.

Rồi một anh senior developer hỏi rất nhẹ nhàng:

> Bạn đã thử `/compact` chưa?

Tôi chưa từng thử.

Anh ấy gõ một command. Toàn bộ session được nén lại thành một summary gọn gàng, các quyết định quan trọng vẫn được giữ lại, và chúng tôi tiếp tục làm việc mà không bị mất mạch.

Đó là lúc tôi nhận ra mình đã dùng Claude Code như một chat box, thay vì như một môi trường phát triển.

Đây là bài viết ngắn mà tôi ước mình đã đọc sớm hơn.

## Trước tiên: Kiểm tra version

Claude Code thay đổi rất nhanh, nên command có sẵn hay không còn phụ thuộc vào version, plan và môi trường bạn đang dùng.

Trước khi học thuộc bất kỳ danh sách command nào, hãy chạy:

~~~bash
claude --version
~~~

Sau đó trong Claude Code, gõ:

~~~
/help
~~~

hoặc chỉ cần gõ `/` để xem những command có sẵn trong session hiện tại.

Hai tài liệu chính thức nên bookmark:

- [Claude Code commands reference](https://code.claude.com/docs/en/commands)
- [Claude Code interactive mode reference](https://code.claude.com/docs/en/interactive-mode)

## 1. `/init`: Tạo project memory một lần

Mỗi project mới thường bắt đầu bằng cùng một sự lặp lại: giải thích tech stack, cấu trúc thư mục, coding style, dependencies, và các command thường dùng.

`/init` giúp tạo file `CLAUDE.md` khởi đầu cho project.

Thay vì tự viết lại context thủ công, chạy:

~~~
/init
~~~

Claude sẽ đọc repository và tạo một project guide để có thể tái sử dụng trong các session sau.

Những thứ command này thường giúp tiết kiệm:

- Lặp lại setup instructions
- Giải thích architecture mỗi lần mở session mới
- Nhắc lại test và build commands
- Nhắc lại code style preferences

Hãy xem `CLAUDE.md` như tài liệu sống. Review, chỉnh sửa, và chỉ giữ lại những instruction thật sự hữu ích.

## 2. `/memory`: Chỉnh những gì Claude cần nhớ

Sau vài project, bạn sẽ bắt đầu lặp lại các preference cá nhân:

- Ưu tiên test trước
- Thay đổi code một cách surgical
- Tránh abstraction không cần thiết
- Giải thích logic khó hiểu bằng comment ngắn
- Không dùng `any` trong TypeScript nếu không có lý do rõ ràng

`/memory` mở các memory file mà Claude Code dùng cho persistent instructions.

~~~
/memory
~~~

Dùng nó cho preference lâu dài, không phải chi tiết tạm thời của một task. Nếu instruction chỉ liên quan tới bug hiện tại, hãy để trong conversation hiện tại. Nếu nó nên ảnh hưởng tới nhiều project sau này, memory có thể là nơi phù hợp.

## 3. GitHub PR comments: Hỏi Claude trực tiếp

Các version Claude Code cũ từng có `/pr-comments`, nhưng commands reference hiện tại đánh dấu command này đã bị remove. Workflow hiện tại đơn giản hơn: hỏi Claude trực tiếp để kiểm tra pull request comments.

Ví dụ:

~~~
Check the comments on the current pull request and summarize what needs to change.
~~~

hoặc:

~~~
Read PR #42 comments and help me address them.
~~~

Cách này giúp bạn không phải chuyển liên tục giữa GitHub và Claude Code, nhưng vẫn giữ cuộc thảo luận bám sát review feedback. Thông thường bạn sẽ cần `gh` CLI đã authenticate cho các workflow liên quan tới GitHub.

## 4. `/btw`: Hỏi câu ngoài lề mà không làm bẩn context

Đôi khi bạn đang làm sâu trong một task thì xuất hiện câu hỏi nhỏ:

- File config đó tên gì?
- Vì sao mình dùng JWT thay vì session cookies?
- Lúc nãy mình đã quyết định gì về retry?

Nếu hỏi bình thường, câu hỏi ngoài lề đó sẽ đi vào main conversation. `/btw` giữ nó tách riêng.

~~~
/btw what was the config file Claude edited earlier?
~~~

Side question có thể dùng context hiện tại, nhưng không trở thành một phần của main history. Nó rất hữu ích cho những câu trả lời nhanh không nên làm lệch task chính.

## 5. `/compact`: Cứu các session quá dài

Session dài thường rất nhiễu. Bạn tích lũy logs, hướng thử sai, ý tưởng dang dở, và context cũ không còn quan trọng.

`/compact` tóm tắt conversation hiện tại và giải phóng context.

~~~
/compact
~~~

Bạn cũng có thể thêm instruction cụ thể:

~~~
/compact keep the implementation decisions, failing tests, and remaining TODOs
~~~

Dùng command này khi:

- Session bắt đầu chậm
- Conversation có quá nhiều hướng đi sai
- Bạn chuyển từ investigation sang implementation
- Bạn muốn tiếp tục vào ngày mai mà không kéo theo toàn bộ transcript

## 6. `!`: Chạy shell command ngay trong Claude Code

Shell mode cho phép bạn chạy command trực tiếp từ prompt của Claude Code bằng cách bắt đầu với `!`.

~~~bash
! npm test
! git status
! ls -la
~~~

Output của command được thêm vào session, nên Claude có thể phản hồi dựa trên kết quả đó.

Cách này đặc biệt hữu ích cho feedback loop ngắn:

~~~bash
! npm install
! npm run test
! git diff
~~~

Thay vì copy terminal output ngược lại vào chat, hãy giữ command và kết quả trong cùng một workflow.

## 7. `/context`: Xem thứ gì đang chiếm context window

Khi session bắt đầu nặng, đoán mò là chưa đủ. `/context` cho bạn thấy thứ gì đang tiêu thụ context window.

~~~
/context
~~~

Dùng nó trước khi compact nếu bạn muốn hiểu vấn đề đến từ:

- Logs được paste quá dài
- File được đọc lặp lại nhiều lần
- Tool output
- Memory quá nhiều
- Conversation đơn giản là đã kéo dài quá lâu

Context management nhờ vậy trở nên cụ thể hơn, thay vì cảm giác mơ hồ.

## Workflow cuối cùng đã hiệu quả với tôi

Workflow Claude Code hiện tại của tôi thường như sau:

1. Chạy `/init` trong project mới.
2. Giữ preference lâu dài trong `/memory`.
3. Dùng `!` cho terminal checks nhanh.
4. Dùng `/btw` cho side questions.
5. Dùng `/context` khi session có vẻ nặng.
6. Dùng `/compact` trước khi conversation trở thành một mớ rối.
7. Hỏi Claude trực tiếp về PR review comments thay vì dựa vào command name đã bị remove.

Điểm khác biệt không nằm ở một command thần kỳ. Nó nằm ở việc hiểu rằng Claude Code có workflow primitives, không chỉ là một ô prompt.

## Lời khuyên cuối

Đừng cố học thuộc mọi command.

Bắt đầu với những command giảm ma sát hằng ngày:

- `/init`
- `/memory`
- `/btw`
- `/compact`
- `/context`
- `!`

Sau đó gõ `/` trong Claude Code mỗi khi bạn muốn biết còn gì khác có thể dùng. Command menu là cách nhanh nhất để khám phá feature phù hợp với version và môi trường hiện tại của bạn.
