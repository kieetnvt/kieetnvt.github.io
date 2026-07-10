---
layout: post
title: "Những Điều Ít Ai Nói Khi Mở Rộng Ứng Dụng Node.js"
subtitle: "Các nút thắt xuất hiện khi một ứng dụng nhỏ bắt đầu phát triển"
cover-img: /assets/img/nodejs_bg.png
thumbnail-img: /assets/img/nodejs_bg.png
share-img: /assets/img/nodejs_bg.png
tags: [nodejs, scaling, backend, performance, vietnamese]
author: kieetnvt
lang: vi
ref: what-nobody-tells-you-about-scaling-node-js
---

# Những Điều Ít Ai Nói Khi Mở Rộng Ứng Dụng Node.js

Node.js mang lại cảm giác rất đơn giản khi ứng dụng còn nhỏ: một tiến trình, một máy chủ và một luồng xử lý request dễ hiểu.

Sau đó, lưu lượng truy cập tăng lên. Một dịch vụ phụ thuộc phản hồi chậm khiến request ùn lại, mức sử dụng bộ nhớ dần tăng và mỗi lần triển khai trở nên căng thẳng hơn. Chẳng bao lâu sau, sẽ có người nói: “Node.js không có khả năng mở rộng tốt.”

Kết luận đó chưa phản ánh đúng vấn đề. Node.js có thể mở rộng, nhưng những khó khăn thực sự hiếm khi được giải quyết chỉ bằng cách đổi framework hoặc mua máy chủ lớn hơn. Việc mở rộng đòi hỏi bạn hiểu rõ độ trễ, trạng thái dùng chung, áp lực lên cơ sở dữ liệu, khả năng xử lý đồng thời, bộ nhớ và sự cố trong môi trường nhiều tiến trình.

Dưới đây là tám bài học thường trở nên quan trọng khi một ứng dụng Node.js vượt qua giai đoạn ban đầu.

### 1. Độ Trễ Thường Trở Thành Vấn Đề Trước CPU

Một lo ngại phổ biến là Node.js chỉ sử dụng một luồng JavaScript nên CPU chắc chắn phải là giới hạn đầu tiên. Công việc nặng về tính toán đúng là có thể chặn event loop, nhưng nhiều ứng dụng backend gặp vấn đề về độ trễ sớm hơn.

Hãy xem xét một endpoint thực hiện các bước sau:

- truy vấn cơ sở dữ liệu
- gọi một API bên ngoài
- ghi log
- định dạng một JSON response lớn

Mỗi thao tác có thể là bất đồng bộ, nhưng tổng thời gian phản hồi vẫn bao gồm mọi dịch vụ phụ thuộc và mọi lượt trao đổi không cần thiết. Khi nhiều request đồng thời cùng chờ các tài nguyên chậm, độ trễ ở nhóm request chậm nhất sẽ tăng lên; connection pool hoặc dịch vụ phía sau cũng có thể bị quá tải ngay cả khi mức sử dụng CPU vẫn có vẻ bình thường.

Hãy bắt đầu bằng cách giảm chi phí của từng request:

- giảm số lượt trao đổi qua mạng và với cơ sở dữ liệu
- chạy đồng thời các thao tác độc lập khi an toàn
- tránh các lệnh `await` tuần tự nếu chúng không phụ thuộc lẫn nhau
- chỉ trả về dữ liệu client thực sự cần
- đo độ trễ p95 và p99 thay vì chỉ nhìn vào giá trị trung bình

Thêm máy chủ có thể tăng năng lực xử lý, nhưng không thể sửa một luồng request vốn đã quá tốn kém.

### 2. Mở Rộng Theo Chiều Ngang Làm Thay Đổi Ứng Dụng

Một tiến trình Node.js chạy JavaScript trên một luồng chính. Trên máy có nhiều lõi CPU, thông thường bạn cần nhiều tiến trình hoặc worker thread để tận dụng hiệu quả nhiều lõi, tùy thuộc vào loại công việc.

Các phương án triển khai phổ biến gồm:

- cluster mode của Node.js hoặc trình quản lý tiến trình như PM2
- nhiều container phía sau load balancer
- hệ thống điều phối như Kubernetes
- nền tảng ứng dụng được quản lý, có thể tự thêm hoặc bớt instance

Ví dụ, PM2 có thể khởi động một tiến trình cho mỗi lõi CPU khả dụng:

~~~bash
pm2 start app.js -i max
~~~

Mức cải thiện throughput thực tế phụ thuộc vào ứng dụng, các dịch vụ phía sau và cấu hình máy. Hãy benchmark với workload của chính bạn thay vì mặc định tin vào một hệ số cố định.

Việc thêm tiến trình cũng tạo ra một vấn đề quan trọng hơn: trạng thái ứng dụng không còn tự động được chia sẻ.

### 3. Trạng Thái Trong Bộ Nhớ Sẽ Hỏng Khi Có Nhiều Instance

Ứng dụng có thể hoạt động hoàn hảo với một tiến trình nhưng gặp những lỗi khó nhận biết ngay khi có thêm instance thứ hai. Người dùng có thể mất session, giới hạn request trở nên thiếu nhất quán, thông điệp WebSocket đến nhầm tiến trình và tệp tải lên chỉ tồn tại trên một máy.

Cách làm sau chỉ an toàn trong phạm vi một tiến trình:

~~~javascript
const sessions = {};
~~~

Khi request có thể được chuyển đến các instance khác nhau, trạng thái cần duy trì hoặc chia sẻ phải được lưu ở bên ngoài. Tùy trường hợp, bạn có thể dùng:

- Redis hoặc cơ sở dữ liệu để lưu session
- một kho dùng chung cho bộ đếm giới hạn request
- object storage cho tệp tải lên
- message broker cho sự kiện và tác vụ nền
- WebSocket adapter khi kết nối trải rộng trên nhiều tiến trình

Hãy thiết kế các tiến trình để có thể thay thế bất cứ lúc nào. Nếu một instance có thể khởi động lại mà không làm mất dữ liệu quan trọng hoặc gây sai hành vi, việc mở rộng theo chiều ngang sẽ dễ dàng hơn nhiều.

### 4. Cơ Sở Dữ Liệu Thường Trở Thành Nút Thắt

Thêm instance ứng dụng cũng làm tăng số lượng client kết nối tới cơ sở dữ liệu. Nếu mỗi request thực hiện nhiều truy vấn kém hiệu quả, mở rộng tầng Node.js còn có thể khiến áp lực lên cơ sở dữ liệu nặng hơn.

Các dấu hiệu cảnh báo thường gặp gồm:

- thiếu index hoặc index không hiệu quả
- liên tục truy vấn lại cùng một dữ liệu
- mẫu truy vấn N+1
- tổng connection pool quá lớn khi có nhiều instance
- transaction chậm giữ khóa lâu hơn cần thiết

Giải pháp thường bắt đầu từ việc hiểu rõ cách ứng dụng truy cập dữ liệu:

- xem execution plan và tối ưu các truy vấn tốn kém
- thêm index phù hợp với điều kiện lọc và phép join thực tế
- cache có chọn lọc các luồng truy cập thường xuyên
- gom nhóm các thao tác đọc và ghi liên quan
- dùng read replica khi có thể chấp nhận sự đánh đổi về tính nhất quán
- đặt giới hạn connection pool dựa trên tổng số instance

Nhiều vấn đề tưởng như do Node.js không thể mở rộng thực chất là vấn đề của cơ sở dữ liệu hoặc dịch vụ phụ thuộc, được bộc lộ qua một API Node.js.

### 5. Bất Đồng Bộ Không Có Nghĩa Là Không Giới Hạn

Mã bất đồng bộ cải thiện khả năng tận dụng tài nguyên bằng cách cho phép công việc khác tiếp tục trong lúc một thao tác đang chờ. Nó không làm cho năng lực của hệ thống phía sau trở thành vô hạn.

Đoạn mã sau có thể khởi chạy hàng trăm request cùng lúc:

~~~javascript
await Promise.all(users.map((user) => fetchProfile(user.id)));
~~~

Điều này có thể làm cạn socket, lấp đầy connection pool, kích hoạt rate limit hoặc khiến một dịch vụ khác quá tải.

Thay vào đó, hãy kiểm soát mức độ đồng thời:

- giới hạn số thao tác đang chạy
- gộp request nếu dịch vụ phía sau hỗ trợ
- đưa công việc có lưu lượng đột biến vào hàng đợi
- áp dụng backpressure cho stream và consumer
- chủ động thiết kế timeout, retry và exponential backoff

Mục tiêu không phải là mức song song lớn nhất, mà là throughput bền vững cao nhất trong khi toàn bộ hệ thống vẫn khỏe mạnh.

### 6. Bộ Nhớ Và Garbage Collection Ảnh Hưởng Đến Độ Trễ

Khi lưu lượng tăng, ứng dụng tạo ra nhiều object hơn và luân chuyển nhiều dữ liệu hơn trong bộ nhớ. V8 cuối cùng phải thu hồi những object không còn được tham chiếu. Phần lớn công việc garbage collection diễn ra theo từng bước nhỏ, nhưng áp lực cấp phát và heap lớn vẫn có thể góp phần tạo ra các đợt tăng độ trễ.

Hãy theo dõi:

- mức sử dụng heap tăng liên tục
- garbage collection diễn ra thường xuyên hoặc kéo dài
- payload lớn được giữ trong bộ nhớ
- cache, mảng hoặc hàng đợi không có giới hạn
- object bị giữ lại, có thể là dấu hiệu rò rỉ bộ nhớ

Những cải thiện thực tế gồm stream tệp và response lớn, đặt giới hạn rõ ràng cho cache, tránh sao chép object lớn khi không cần thiết và dùng heap snapshot khi bộ nhớ không trở về mức cơ sở như mong đợi.

Hãy theo dõi mức sử dụng heap và độ trễ event loop bên cạnh tổng RAM của tiến trình. Chúng phản ánh những khía cạnh khác nhau của vấn đề.

### 7. Ghi Log Có Chi Phí Thực Sự

Ghi log cần thực hiện tuần tự hóa dữ liệu và I/O. Khi lưu lượng thấp, chi phí đó dễ bị bỏ qua; nhưng trên luồng xử lý nóng, nó có thể trở nên đáng kể.

Không nên mặc định ghi lại toàn bộ request body:

~~~javascript
console.log(req.body);
~~~

Payload lớn hoặc chứa dữ liệu nhạy cảm làm tăng khối lượng log, khiến quá trình thu thập chậm hơn và tạo ra rủi ro bảo mật. Một chiến lược ghi log tốt hơn cho production nên:

- sử dụng log có cấu trúc
- kèm request ID hoặc trace ID
- lựa chọn log level có chủ đích
- che giấu secret và dữ liệu cá nhân
- lấy mẫu các sự kiện có tần suất cao khi phù hợp
- gửi log qua transport không chặn luồng xử lý

Log nên giúp giải thích sự cố và những thay đổi trạng thái quan trọng mà không trở thành một nút thắt mới.

### 8. Mở Rộng Là Bài Toán Kiến Trúc

Đến một thời điểm, cải thiện mã nguồn cục bộ là chưa đủ. Một ứng dụng phân tán phải xử lý sự cố cục bộ, thông điệp trùng lặp, retry và sự thiếu nhất quán tạm thời.

Điều đó có thể đòi hỏi:

- hàng đợi cho công việc chậm hoặc có lưu lượng đột biến
- consumer và thao tác API có tính idempotent
- timeout và circuit breaker quanh các dịch vụ phụ thuộc
- khả năng quan sát xuyên qua ranh giới dịch vụ
- tách cẩn thận các thành phần có nhu cầu mở rộng khác nhau

Điều này không có nghĩa mọi ứng dụng đang phát triển đều phải lập tức chuyển thành một tập hợp microservice. Một monolith có cấu trúc tốt thường đơn giản hơn khi vận hành. Chỉ nên tách thành phần khi có lý do cụ thể về vận hành hoặc tổ chức, đồng thời tính đến chi phí mạng và tính nhất quán phát sinh từ việc chia tách.

### Lời Kết

Node.js hiếm khi là lý do duy nhất khiến ứng dụng gặp khó khăn dưới tải cao. Vấn đề thường đến từ luồng request tốn kém, mức đồng thời không giới hạn, trạng thái chỉ tồn tại trong một instance, truy cập cơ sở dữ liệu kém hiệu quả, áp lực bộ nhớ hoặc kiến trúc giả định rằng các dịch vụ phụ thuộc không bao giờ gặp lỗi.

Hãy tôn trọng event loop, kiểm soát mức độ đồng thời, giữ các instance không lưu trạng thái và đo lường hệ thống trước khi quyết định cần mở rộng phần nào. Mục tiêu không phải là thêm càng nhiều máy chủ càng tốt, mà là giúp năng lực xử lý trở nên dễ dự đoán và sự cố dễ kiểm soát khi ứng dụng phát triển.
