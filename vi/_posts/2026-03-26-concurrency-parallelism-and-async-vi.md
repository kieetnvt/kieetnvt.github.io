---
layout: post
title: "Concurrency, Parallelism Và Async: Ba Khái Niệm Dễ Bị Nhầm Lẫn"
subtitle: Cách phần mềm hiện đại xử lý nhiều tác vụ mà không dùng sai công cụ
cover-img: /assets/img/codebg.webp
thumbnail-img: /assets/img/codebg.webp
share-img: /assets/img/codebg.webp
tags: [programming, concurrency, parallelism, async, ruby, system-design, vietnamese]
author: kieetnvt
lang: vi
ref: concurrency-parallelism-and-async
---

Mọi developer đều từng nghe các từ **concurrency**, **parallelism**, và **async**.

Nhiều developer cũng dùng chúng như thể chúng có cùng nghĩa.

Không phải vậy.

Cả ba khái niệm đều trả lời cùng một câu hỏi ở bề mặt:

> Làm sao để chương trình của tôi xử lý nhiều hơn một việc?

Nhưng chúng trả lời ở các tầng khác nhau. Concurrency nói về cấu trúc. Parallelism nói về cách thực thi. Async là một mô hình lập trình để tránh lãng phí thời gian chờ.

Nhầm lẫn giữa chúng có thể dẫn đến quyết định kiến trúc sai, thêm thread không cần thiết, bug khó đoán, và tối ưu hiệu năng không chạm đúng bottleneck.

Hãy tách chúng ra cho rõ.

## Ví Dụ Nhà Bếp

Tưởng tượng một đầu bếp đang chuẩn bị bữa tối ba món.

Cô ấy bắt đầu luộc mì, rồi thái rau trong lúc chờ nước sôi. Đó là **concurrency**: nhiều tác vụ đang diễn ra, nhưng vẫn chỉ có một người đang chuyển qua lại giữa các việc.

Nếu nhà hàng thuê thêm một đầu bếp khác để chuẩn bị salad cùng lúc, đó là **parallelism**: hai người thật sự làm việc đồng thời.

Nếu đầu bếp cho món ăn vào lò, đặt hẹn giờ, rồi đi phục vụ bàn khác thay vì đứng nhìn lò, đó là ý tưởng cơ bản của **async**: đừng block trong lúc chờ.

Cùng một căn bếp. Nhưng là các chiến lược khác nhau.

## Concurrency: Tung Hứng Công Việc

Concurrency nghĩa là nhiều tác vụ đang **in progress** trong cùng một khoảng thời gian, nhưng không nhất thiết đang chạy đúng cùng một khoảnh khắc.

Trên một CPU core, tại một thời điểm chỉ có một instruction chạy. Hệ điều hành vẫn có thể làm nhiều tác vụ trông như đang hoạt động bằng cách chuyển qua lại rất nhanh giữa chúng. Cơ chế này gọi là **time-slicing** hoặc **context switching**.

Nhìn từ bên ngoài, mọi thứ có vẻ đang xảy ra cùng lúc. Bên dưới, các tác vụ đang thay phiên nhau.

Concurrency hữu ích khi tác vụ phải chờ:

- đọc file
- query database
- gọi external API
- chờ cache
- xử lý nhiều web request

Đây thường là các tác vụ **I/O-bound**. CPU không bận toàn thời gian. Nó dành nhiều thời gian để chờ thứ khác.

Concurrency cho phép chương trình làm tiếp việc khác trong những khoảng chờ đó.

## Parallelism: Thật Sự Chạy Cùng Lúc

Parallelism nghĩa là nhiều tác vụ chạy **đúng cùng một thời điểm**, thường trên các CPU core khác nhau.

Không còn chuyện thay phiên. Nếu bạn có hai core, hai phần công việc có thể chạy đồng thời. Nếu bạn có tám core và bài toán có thể chia nhỏ sạch sẽ, nhiều việc hơn có thể diễn ra cùng lúc.

Parallelism hữu ích cho các tác vụ **CPU-bound**:

- xử lý ảnh
- encode video
- nén dữ liệu
- nhân ma trận
- machine learning inference
- chuyển đổi dữ liệu lớn

Các tác vụ này dành phần lớn thời gian dùng CPU trực tiếp. Nếu công việc có thể chia thành các phần độc lập, parallelism có thể giảm thời gian thực tế phải chờ.

Nhưng parallelism có chi phí.

## Cái Giá Của Parallelism

Code chạy song song thường kéo theo vấn đề shared state.

Nếu hai core đọc và ghi cùng một vùng nhớ tại cùng thời điểm, kết quả có thể phụ thuộc vào timing. Đó là **race condition**.

Để tránh race condition, bạn có thể cần mutex, semaphore, atomic, queue, immutable data, hoặc actor-style isolation. Các công cụ này hữu ích, nhưng làm hệ thống phức tạp hơn. Lock cũng có thể trở thành bottleneck thông qua **lock contention**, khi nhiều worker phải chờ quyền truy cập cùng một tài nguyên.

Vì vậy, "cứ làm multi-threaded" không tự nó là một chiến lược hiệu năng. Parallelism chỉ giúp khi:

- công việc là CPU-bound
- các tác vụ đủ độc lập
- có CPU core rảnh
- chi phí phối hợp thấp hơn phần công việc tiết kiệm được

Nếu các điều kiện đó không đúng, parallelism có thể làm hệ thống chậm hơn và khó hiểu hơn.

## Async: Chờ Mà Không Block

Async là một mô hình lập trình để xử lý việc chờ một cách hiệu quả.

Ý tưởng chính rất đơn giản: khi một tác vụ phải chờ I/O, đừng block thread. Đăng ký thao tác đang chờ, để runtime làm việc khác, rồi tiếp tục tác vụ khi có kết quả.

Trong nhiều runtime, việc này được điều phối bởi một **event loop**.

Ví dụ, một request handler cần lấy thông tin user và danh sách order. Phiên bản blocking có thể làm như sau:

1. Hỏi database để lấy user.
2. Chờ.
3. Hỏi database để lấy orders.
4. Chờ.
5. Tạo response.

Phiên bản async có thể bắt đầu cả hai lần chờ và tiếp tục khi dữ liệu quay về. Tổng thời gian chờ sẽ gần với thao tác chậm hơn, thay vì tổng của cả hai lần chờ.

Đó là lợi ích chính: async giúp thread không ngồi yên trong lúc chờ.

Async không có nghĩa là parallel. Một event loop single-threaded có thể xử lý nhiều tác vụ concurrently, nhưng tại một thời điểm chỉ có một đoạn code chạy trên thread đó.

## Ví Dụ Nhỏ Với Ruby

Ruby fibers là một cách hữu ích để hiểu cooperative concurrency. Ví dụ này được đơn giản hóa, nhưng cho thấy hình dạng của việc tạm dừng và tiếp tục công việc:

~~~ruby
fetch_user = Fiber.new do
  puts "Fetching user..."
  Fiber.yield "User: Alice"
end

fetch_orders = Fiber.new do
  puts "Fetching orders..."
  Fiber.yield "Orders: [#1, #2, #3]"
end

user = fetch_user.resume
orders = fetch_orders.resume

puts user
puts orders
~~~

Trong ứng dụng thực tế, async runtime điều phối I/O readiness, scheduling, và việc resume task. Điều quan trọng là công việc có thể tạm dừng tại các điểm đã biết và tiếp tục sau đó, mà không block cả một thread trong lúc chờ.

## Ba Khái Niệm Này Liên Quan Thế Nào

Mental model gọn nhất là:

- **Concurrency** nói về cấu trúc: nhiều tác vụ có thể cùng tiến triển trong cùng một khoảng thời gian.
- **Parallelism** nói về thực thi: nhiều tác vụ thật sự chạy cùng lúc.
- **Async** là một kỹ thuật để đạt concurrency: task tạm dừng khi chờ và resume sau.

Chúng không loại trừ nhau.

Một web server có thể dùng async I/O để xử lý nhiều kết nối. Nó có thể dùng thread pool cho các thư viện blocking. Nó có thể gửi job nặng CPU sang worker process chạy song song trên nhiều core.

Hệ thống thực tế thường kết hợp cả ba. Điều quan trọng là biết mình đang xử lý ở tầng nào.

## Framework Ra Quyết Định

Khi gặp vấn đề hiệu năng hoặc scaling, hãy hỏi các câu sau trước khi chọn thread, async, hoặc worker pool.

### 1. Bottleneck Là CPU Hay I/O?

Hãy profile trước.

Nếu phần lớn thời gian nằm ở database, cache, file, hoặc HTTP call, bạn có thể đang gặp bài toán I/O-bound. Concurrency hoặc async có thể giúp.

Nếu phần lớn thời gian nằm ở tính toán, encode, parse, nén, hoặc transform dữ liệu, bạn có thể đang gặp bài toán CPU-bound. Parallelism có thể giúp.

### 2. Có Bao Nhiêu Tác Vụ Cần Active?

Vài chục thread có thể hoàn toàn ổn.

Hàng nghìn connection có thể rất tốn kém nếu mỗi connection cần một thread riêng. Trong trường hợp đó, async I/O hoặc lightweight concurrency primitives có thể phù hợp hơn.

### 3. Các Tác Vụ Có Chia Sẻ State Không?

Shared mutable state là nơi nhiều bug xuất hiện.

Nếu các tác vụ cần cập nhật cùng một dữ liệu, parallelism trở nên khó hơn. Bạn cần locking, queue, atomic operation, immutable data structure, hoặc isolation.

Nếu công việc có thể được làm độc lập, thiết kế sẽ an toàn hơn nhiều.

### 4. Runtime Của Bạn Hỗ Trợ Gì Tốt?

Mỗi ngôn ngữ có điểm mạnh khác nhau.

Node.js được xây quanh async I/O. Go có goroutines và channels. Ruby MRI có Global VM Lock, nên Ruby threads rất hữu ích cho I/O-bound concurrency nhưng không phù hợp cho CPU-bound parallel Ruby execution. Ruby 3 giới thiệu Ractors để chạy song song với isolated state.

Hãy dùng mô hình mà runtime hỗ trợ tốt trước khi ép một mô hình khác vào.

## Ruby Là Một Ví Dụ Thực Tế

Ruby là một lăng kính tốt vì nó cho thấy sự khác biệt rất rõ.

MRI Ruby có **Global VM Lock**. Tại một thời điểm, chỉ một Ruby thread thực thi Ruby code. Điều đó nghĩa là Ruby threads không đem lại true parallelism cho Ruby code CPU-bound.

Nhưng Ruby threads vẫn rất hữu ích cho ứng dụng web I/O-bound. Trong nhiều lúc chờ I/O, runtime có thể nhả lock và cho thread khác tiếp tục.

Ruby 3 giới thiệu **Ractors**, cho phép true parallel execution với isolated state. Ractors tránh shared mutable memory bằng cách giao tiếp qua message passing. Điều này an toàn hơn cho parallelism, nhưng cũng nghiêm ngặt hơn so với object và thread thông thường.

Các thư viện async trong Ruby dùng fibers và event loops để làm việc chờ trở nên rẻ hơn. Cách này có thể giúp một process xử lý nhiều tác vụ nặng I/O mà không cần tạo một thread cho mỗi request.

Điểm chính không phải là mô hình nào thắng. Điểm chính là mỗi mô hình giải quyết một vấn đề khác nhau.

## Amdahl's Law: Giới Hạn Của Tăng Tốc Song Song

Trước khi parallelize mọi thứ, hãy nhớ Amdahl's Law.

Nếu chỉ một phần chương trình có thể chạy song song, phần tuần tự sẽ giới hạn tốc độ tổng thể. Công thức đơn giản là:

~~~text
speedup = 1 / ((1 - p) + (p / n))
~~~

Trong đó:

- `p` là phần chương trình có thể parallelize
- `n` là số processor

Nếu một nửa chương trình vốn dĩ phải chạy tuần tự, ngay cả số processor vô hạn cũng không thể làm toàn bộ chương trình nhanh hơn quá 2 lần.

Đó là lý do profiling quan trọng. Parallelize sai phần của hệ thống chỉ tạo thêm độ phức tạp mà không đem lại speedup đáng kể.

## Những Hiểu Lầm Phổ Biến

**"Multithreading luôn làm mọi thứ nhanh hơn."**

Chỉ đúng khi công việc thật sự hưởng lợi từ nó. I/O-bound work có thể cần concurrency tốt hơn, không phải CPU parallelism nhiều hơn. Shared-state threads cũng có thể tạo thêm overhead.

**"Async nghĩa là parallel."**

Không. Async có thể giúp nhiều tác vụ cùng tiến triển trên một thread, nhưng tại một thời điểm chỉ một đoạn code chạy trên thread đó.

**"Concurrency luôn nguy hiểm."**

Không hẳn. Shared mutable state mới nguy hiểm. Single-threaded async, message passing, queues, và immutable data có thể làm concurrent systems dễ hiểu hơn nhiều.

**"Ruby threads vô dụng vì GVL."**

Không đúng với I/O-bound work. Hầu hết ứng dụng web chờ database, cache, và network call. Ruby threads vẫn có thể cải thiện throughput cho loại workload đó.

## Kết Luận Thực Tế

Hãy dùng thuật ngữ cho chính xác:

- Dùng **concurrency** khi bạn muốn nói nhiều tác vụ đang in progress.
- Dùng **parallelism** khi bạn muốn nói nhiều tác vụ chạy cùng lúc.
- Dùng **async** khi bạn muốn nói một tác vụ có thể chờ mà không block thread.

Với hệ thống I/O-bound, hãy tập trung vào concurrency và non-blocking waits.

Với hệ thống CPU-bound, hãy tìm phần công việc độc lập có thể chạy song song.

Với hệ thống có shared state, hãy thiết kế data flow cẩn thận trước khi thêm worker.

Phần lớn hệ thống có khả năng scale tốt dùng kết hợp cả ba. Khác biệt giữa một thiết kế rõ ràng và một thiết kế mong manh nằm ở việc biết công cụ nào giải quyết bottleneck nào.
