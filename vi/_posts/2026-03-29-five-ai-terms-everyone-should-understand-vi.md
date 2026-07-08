---
layout: post
title: Năm Thuật Ngữ AI Ai Cũng Nên Hiểu
subtitle: Giải thích dễ hiểu về token, context window, temperature, hallucination và RAG
cover-img: /assets/img/rag-cover.jpg
thumbnail-img: /assets/img/rag-cover.jpg
share-img: /assets/img/rag-cover.jpg
tags: [ai, llm, rag, machine-learning, beginners, vietnamese]
author: kieetnvt
lang: vi
ref: five-ai-terms-everyone-should-understand
---

Mọi người nói về AI rất nhiều, nhưng nhiều cuộc trò chuyện vẫn trở nên mơ hồ khi các thuật ngữ như token, context window, hallucination hoặc RAG xuất hiện.

Bạn không cần trở thành nhà nghiên cứu machine learning để dùng AI tốt hơn. Nhưng nếu hiểu một vài khái niệm cốt lõi, bạn có thể viết prompt tốt hơn, đánh giá công cụ AI rõ ràng hơn, và tránh tin mô hình ở những chỗ không nên tin.

Dưới đây là năm thuật ngữ AI rất đáng hiểu cho đúng.

## 1. Token

Mô hình ngôn ngữ AI không đọc văn bản giống con người. Chúng xử lý **token**.

Token là một mảnh nhỏ của văn bản. Đôi khi nó là một từ hoàn chỉnh. Đôi khi nó là một phần của từ. Đôi khi nó là dấu câu hoặc khoảng trắng. Ví dụ, câu:

> I love pizza

có thể được biểu diễn thành vài token như `I`, ` love`, và ` pizza`.

Cách tách chính xác phụ thuộc vào tokenizer của từng mô hình, nhưng ý tưởng thực tế rất đơn giản: token là những đơn vị văn bản mà mô hình nhận vào, xử lý, và sinh ra.

Vì sao điều này quan trọng?

Vì các hệ thống AI đếm token ở phía sau. Prompt của bạn dùng token. Lịch sử hội thoại dùng token. Tài liệu upload lên dùng token. Câu trả lời của mô hình cũng dùng token.

Điều đó ảnh hưởng đến ba thứ:

- **Chi phí:** Giá API thường được tính theo input token và output token.
- **Tốc độ:** Nhiều token hơn thường đồng nghĩa với nhiều việc hơn cho mô hình.
- **Bộ nhớ:** Mô hình chỉ có thể xem xét một số token giới hạn tại một thời điểm.

Khi hiểu token, nhiều hành vi của AI sẽ dễ hiểu hơn. Prompt dài không chỉ là "văn bản dài". Nó là nhiều mảnh hơn để mô hình xử lý. Hội thoại dài không phải là bộ nhớ vô hạn. Nó là ngân sách token đang dần được lấp đầy.

## 2. Context Window

**Context window** là lượng văn bản mà mô hình có thể xem xét tại một thời điểm, được đo bằng token.

Hãy tưởng tượng nó như một chiếc bảng trắng. Mọi thứ mô hình đang thấy phải nằm vừa trên chiếc bảng đó:

- system instructions
- prompt của bạn
- các tin nhắn trước đó
- văn bản được dán vào
- tài liệu được truy xuất
- các câu trả lời trước đó của chính mô hình

Khi chiếc bảng nhỏ, mô hình chỉ làm việc được với lượng thông tin hạn chế. Khi chiếc bảng lớn, nó có thể xem xét các cuộc hội thoại dài hơn và tài liệu lớn hơn.

Đây là lý do một trợ lý AI đôi khi có vẻ quên những phần đầu của cuộc trò chuyện. Có thể nó không cố tình bỏ qua bạn. Phần nội dung cũ có thể không còn nằm trong context đang hoạt động, hoặc ứng dụng đã tóm tắt hay loại bỏ một phần nội dung đó.

Context window lớn rất hữu ích, nhưng không phải phép màu. Nhiều context hơn cũng có thể nghĩa là nhiều thông tin không liên quan hơn để mô hình phải lọc. Nếu bạn dán một tài liệu rất dài và hỏi một câu mơ hồ, mô hình vẫn phải tự quyết định phần nào quan trọng.

Bài học thực tế: khi dùng AI cho việc quan trọng, hãy đặt thông tin liên quan gần với câu hỏi. Đừng mặc định rằng mô hình nhớ mọi chi tiết từ một cuộc trò chuyện dài.

## 3. Temperature

**Temperature** điều khiển mức độ dự đoán được hoặc đa dạng trong đầu ra của mô hình.

Ở temperature thấp, mô hình có xu hướng chọn các token tiếp theo an toàn hơn và có xác suất cao hơn. Kết quả thường nhất quán hơn và ít bất ngờ hơn.

Ở temperature cao hơn, mô hình được phép mạo hiểm hơn. Đầu ra có thể sáng tạo hơn, đa dạng hơn, và đôi khi kém tin cậy hơn.

Ví dụ, nếu bạn yêu cầu mô hình hoàn thành câu:

> The cat sat on the...

Ở temperature thấp, nó có thể chọn một từ hiển nhiên như `mat` hoặc `floor`.

Ở temperature cao hơn, nó có thể chọn một cụm từ lạ, thơ hơn, hoặc kỳ quặc hơn.

Không có thiết lập nào luôn tốt hơn. Nó phụ thuộc vào tác vụ.

Dùng temperature thấp hơn cho các việc cần tính nhất quán:

- tóm tắt tài liệu
- trích xuất thông tin có cấu trúc
- viết code
- trả lời câu hỏi mang tính factual
- tuân theo định dạng nghiêm ngặt

Dùng temperature cao hơn khi sự đa dạng có ích:

- brainstorming
- viết truyện
- nghĩ tên ý tưởng
- viết marketing copy
- thử nhiều cách diễn đạt khác nhau

Nhiều ứng dụng AI phổ thông không cho chỉnh temperature trực tiếp, nhưng công cụ dành cho developer và API thường có. Nếu bạn thấy thiết lập này, hãy nghĩ về nó như một nút điều chỉnh mức độ ngẫu nhiên bạn muốn trong câu trả lời.

## 4. Hallucination

**Hallucination** là khi mô hình AI tạo ra một câu trả lời nghe rất tự tin nhưng sai.

Điều nguy hiểm không chỉ là mô hình có thể mắc lỗi. Công cụ nào cũng có thể mắc lỗi. Điều nguy hiểm là mô hình có thể trình bày một câu trả lời bịa ra bằng cùng giọng điệu mà nó dùng khi trả lời đúng.

Ví dụ, bạn có thể hỏi về một cuốn sách, một vụ kiện, một hàm trong thư viện, hoặc một sự kiện lịch sử. Nếu mô hình không thật sự có câu trả lời, nó vẫn có thể sinh ra thứ nghe rất hợp lý: tiêu đề, tác giả, năm xuất bản, trích dẫn, hoặc một API không tồn tại.

Điều này xảy ra vì mô hình ngôn ngữ không phải là cơ sở dữ liệu. Chúng sinh ra văn bản có khả năng hợp lý dựa trên các mẫu đã học trong quá trình huấn luyện và context được cung cấp lúc chạy. Chúng không tự động xác minh sự thật, trừ khi hệ thống xung quanh cung cấp công cụ hoặc nguồn được truy xuất để làm việc đó.

Bài học thực tế rất rõ: dùng AI như điểm khởi đầu, không phải thẩm quyền cuối cùng.

Hãy đặc biệt cẩn thận với:

- câu hỏi pháp lý
- lời khuyên y tế
- quyết định tài chính
- code nhạy cảm về bảo mật
- thống kê và benchmark
- tên riêng, ngày tháng, và trích dẫn

Với các việc soạn thảo rủi ro thấp, hallucination có thể chỉ gây khó chịu. Với các quyết định rủi ro cao, nó có thể là vấn đề nghiêm trọng. Người dùng AI tốt không tin mù quáng. Họ kiểm chứng.

## 5. RAG

**RAG** là viết tắt của **Retrieval-Augmented Generation**.

Nghe có vẻ phức tạp, nhưng ý tưởng cốt lõi rất đơn giản: trước khi mô hình trả lời, hệ thống truy xuất thông tin liên quan và đưa thông tin đó cho mô hình làm context.

Cách này giải quyết một vấn đề phổ biến. Mô hình có thể không biết tài liệu công ty của bạn, ghi chú riêng, chính sách hỗ trợ mới nhất, hoặc file PDF bạn vừa upload. Thay vì huấn luyện lại mô hình mỗi khi có thông tin mới, hệ thống RAG làm một việc thực tế hơn:

1. Chia tài liệu thành các chunk nhỏ hơn.
2. Lưu các chunk đó vào một cơ sở dữ liệu có thể tìm kiếm, thường dùng embeddings.
3. Khi người dùng đặt câu hỏi, tìm các chunk liên quan nhất.
4. Đưa các chunk đó vào prompt.
5. Yêu cầu mô hình trả lời dựa trên context đó.

Luồng cơ bản là:

> truy xuất context hữu ích, đưa nó cho mô hình, rồi sinh câu trả lời.

Đây là cách nhiều công cụ "chat với PDF" hoạt động. Đây cũng là pattern phía sau nhiều trợ lý tri thức nội bộ, bot hỗ trợ khách hàng, và công cụ tìm kiếm tài liệu.

Hiểu RAG sẽ thay đổi cách bạn nhìn các sản phẩm AI. Khi một sản phẩm nói AI "biết tài liệu của bạn", điều đó thường có nghĩa là hệ thống có thể tìm trong tài liệu của bạn và đặt các phần liên quan vào context của mô hình. Mô hình nền không học vĩnh viễn mọi thứ. Ứng dụng chỉ cung cấp context tốt hơn vào đúng thời điểm.

RAG rất mạnh, nhưng không hoàn hảo. Nếu retrieval lấy sai chunk, câu trả lời vẫn có thể sai. Nếu tài liệu đã lỗi thời, câu trả lời có thể phản ánh thông tin lỗi thời. Nếu prompt không buộc mô hình bám sát nguồn, nó vẫn có thể bịa thêm chi tiết.

Một hệ thống RAG tốt cần retrieval tốt, xử lý nguồn rõ ràng, và kiểm chứng cẩn thận.

## Vì Sao Những Thuật Ngữ Này Quan Trọng

Năm ý tưởng này nhỏ, nhưng giải thích được rất nhiều thứ:

- **Token** giải thích vì sao prompt, chi phí, và giới hạn độ dài hoạt động như vậy.
- **Context window** giải thích vì sao AI có thể mất dấu các cuộc hội thoại dài.
- **Temperature** giải thích vì sao cùng một prompt có thể tạo ra câu trả lời an toàn hơn hoặc sáng tạo hơn.
- **Hallucination** giải thích vì sao đầu ra tự tin của AI vẫn cần được kiểm chứng.
- **RAG** giải thích cách các công cụ AI trả lời câu hỏi về tài liệu của chính bạn.

Bạn không cần học thuộc định nghĩa học thuật. Mục tiêu là hiểu để dùng được trong thực tế.

Khi các thuật ngữ này trở nên rõ ràng, AI sẽ bớt giống một chiếc hộp đen bí ẩn và giống hơn một hệ thống có giới hạn cụ thể. Đó là lúc bạn có thể dùng nó với phán đoán tốt hơn.
