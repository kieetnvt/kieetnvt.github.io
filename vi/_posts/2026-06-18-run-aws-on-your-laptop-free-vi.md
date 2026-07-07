---
layout: post
title: Chạy AWS Trên Laptop Miễn Phí
subtitle: Thực hành lệnh AWS, Azure và GCP local mà không lo hóa đơn cloud
cover-img: /assets/img/docker.png
thumbnail-img: /assets/img/docker.png
share-img: /assets/img/docker.png
tags: [aws, gcp, azure, devops, cloud, docker, vietnamese]
author: kieetnvt
lang: vi
ref: run-aws-on-your-laptop-free
---

Thực hành cloud có thể tốn tiền rất nhanh.

Free credits hữu ích khi mới bắt đầu, nhưng chúng hết nhanh nếu bạn thử nghiệm EKS cluster, S3 bucket, queue, secrets, workflow kiểu Lambda, hoặc các dịch vụ cloud thực tế khác. Kết quả thường gặp là: bạn xem lý thuyết, hiểu khái niệm, rồi ngại thực hành vì không muốn nhận hóa đơn bất ngờ.

Có một cách khác để luyện tập: chạy cloud service emulator ngay trên máy local.

## Vấn đề với Free Tier

Vài năm trước, đăng ký AWS, Azure hoặc GCP thường tạo cảm giác khá an toàn vì free tier cho bạn đủ không gian để thử nghiệm. Hiện tại, credits có thể hết rất nhanh nếu bạn thực hành nghiêm túc.

Việc tạo hạ tầng, thử managed services, và lặp lại các tutorial đều có thể phát sinh chi phí sau khi bạn vượt free tier. Rủi ro tài chính này là một trong những lý do khiến nhiều người dừng ở mức học lý thuyết thay vì thực hành cloud thật sự.

## Giải pháp: Emulation local

Emulation nghĩa là các lệnh cloud CLI của bạn sẽ gọi tới một service local có hành vi giống API thật của cloud provider.

Thay vì gửi request lên AWS, Azure hoặc GCP, lệnh của bạn gọi tới emulator đang chạy trên laptop. Emulator trả về response giống response của cloud provider, nên bạn có thể luyện các command và workflow quen thuộc mà không chạm tới hạ tầng cloud thật.

Developer đã dùng ý tưởng này rất thường xuyên. Chúng ta mock database, queue, và service bên ngoài khi phát triển local vì không cần production infrastructure cho mọi lần test. Cách tiếp cận tương tự cũng hiệu quả cho việc học cloud.

## Floci là gì?

[Floci](https://floci.io/#install) là một công cụ open-source để chạy cloud service emulation local. Floci hỗ trợ các cloud provider lớn gồm AWS, Azure và GCP, trong đó AWS hiện có độ phủ dịch vụ rộng nhất.

Link hữu ích:

- [Floci GitHub repository](https://github.com/floci-io/floci)
- [Danh sách dịch vụ Floci hỗ trợ](https://floci.io/floci/services/)

Với mục tiêu thực hành local, điểm quan trọng rất đơn giản: bạn có thể chạy các cloud workflow phổ biến trên máy của mình mà không cần tạo cloud account, thêm credit card, hoặc dùng tài nguyên cloud thật.

## Điều kiện cần

Bạn chỉ cần Docker đang chạy trên máy.

Bạn không cần:

- AWS account
- Azure subscription
- GCP project
- Credit card

## Bước 1: Chạy Floci bằng Docker

Khởi động Floci trong Docker container:

~~~bash
docker run -d --name floci \
  -p 4566:4566 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  floci/floci:latest
~~~

Lệnh này expose local cloud emulator ở port `4566`.

## Bước 2: Trỏ AWS CLI về Floci

Thiết lập environment variables để AWS CLI và AWS SDK gọi tới Floci local thay vì AWS thật:

~~~bash
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
~~~

Credentials có thể là giá trị giả vì toàn bộ request vẫn nằm trên máy local.

## Bước 3: Thử workflow S3 local

Tạo bucket:

~~~bash
aws s3 mb s3://my-bucket
~~~

Tạo file test:

~~~bash
echo "Why pay for S3 when Floci is free?" > hello-floci.txt
~~~

Upload file:

~~~bash
aws s3 cp hello-floci.txt s3://my-bucket/hello-floci.txt
~~~

Download file về lại:

~~~bash
aws s3 cp s3://my-bucket/hello-floci.txt hello-back.txt
cat hello-back.txt
~~~

Bạn vừa thực hành một workflow S3 bằng AWS CLI, nhưng mọi thứ vẫn chạy trên laptop.

## Vì sao cách này hữu ích?

Cloud emulation local giúp bạn thực hành với ít rào cản hơn:

- Dùng command CLI và SDK pattern giống môi trường thật
- Lặp lại tutorial mà không đốt cloud credits
- Thử nghiệm mà không lo quên cleanup rồi bị tính phí
- Test workflow trước khi đụng vào hạ tầng thật
- Học các dịch vụ như S3, EKS, KMS, SQS, Secrets Manager, và EventBridge local khi emulator có hỗ trợ

Đây không phải là giải pháp thay thế hoàn toàn cho hạ tầng cloud thật. Một số hành vi đặc thù của provider, edge case về IAM, giới hạn managed service, chi tiết networking, và vấn đề production deployment vẫn cần kiểm tra trên platform thật.

Nhưng với mục tiêu học, phát triển local, và luyện tập lặp lại, cách này loại bỏ một rào cản lớn.

## Lời kết

Nếu nỗi lo hóa đơn đang khiến bạn ngại thực hành cloud engineering, local emulation là một hướng rất đáng thử.

Cài Docker, chạy Floci, trỏ CLI về `localhost:4566`, rồi thực hành các workflow tương tự như khi làm với AWS, Azure hoặc GCP. Khi sẵn sàng deploy thật, bạn đã quen hơn với command và khái niệm dịch vụ.
