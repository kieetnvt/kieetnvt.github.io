---
layout: post
title: "Understanding NGINX Web Server"
subtitle: "Understanding NGINX Web Server"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/nginx.png
share-img: /assets/img/path.jpg
tags: [nginx webserver]
author: kieetnvt
---

> Basic of NGINX

Việc cài đặt NGINX cho server tôi sẽ bỏ qua trong bài viết này, tại vì có khá nhiều bài viết và tutorial về việc set-up NGINX cho server linux và bài viết này tôi chú trọng vào việc cách sử dụng, cách config, và hiểu những ý nghĩa căn bản về NGINX.

Tôi thích đi theo sự hiểu căn bản. Việc hiểu căn bản sẽ giúp bạn dễ dàng hơn để tiếp cận, cũng như hiểu bản chất nó là gì?.

Một trong những sai lầm của DEV là cố gắng học hiểu những thứ cao siêu kĩ thuật cao mà cái cơ bản thì không biết rõ.

1. Cách start, stop, reload và restart NGINX - Những command đó thực hiện như thế nào?

```
nginx -s signal
```

hay

```
service nginx signal
```

command cần có quyền giống với user cài đặt nginx trên server, thường là phải có quyền root (thêm sudo trong command).

signal là:

- stop: shutdown
- quit: graceful shutdown
- reload: reloading config file
- reopen: reopening the log file

Khi ta có sự thay đổi trong những file config, thì những config chỉ có tác dụng khi chúng ta chạy command reload hoặc nếu NGINX được restart.

NGINX chạy theo kiểu multi-thread, nó có 1 process MASTER và nhiều process WORKER. Khi MASTER process của NGINX nhận một signal reload file, nó sẽ check syntax của file config có valid không, và sẽ áp dụng config đó. Nếu có lỗi config, thì NGINX rollback về config cũ. Nếu config thành công, không bị lỗi gì hết, thì những process WORKER hiện tại sẽ nhận lệnh shutdown, ngừng nhận request mới từ client, sẽ tiếp tục thực hiện những request đang dang dỡ cho tới khi tất cả request đều đã được phục vụ xong. Sau tất cả, WORKER process hiện tại sẽ exit hết. NGINX sẽ restart, với config mới, sinh ra MASTER và những WORKER process mới.

2. Những điểm cơ bản trong config NGINX

NGINX config có main context, main context chứa các directives (events, http, server, location). Derective http chứa directive server, server thì chứa location directive.

```
http {
  server {
    location {
    }
  }
}
```

comment trong file config NGINX bằng dấu #

Một request gửi từ client tới server thì request này sẽ được NGINX sẽ sử dụng server directive để xử lý request này. NGINX sẽ kiểm tra request URI với thông tin HEADER của request URI đó, và quyết định server block nào xử lý, dựa trên server_name nào match với request URI đó, port tương ứng (port 80 http hay port 443 https). Tiếp theo, sau khi đã quyết định được server block xử lý, NGINX sẽ kiểm tra tiếp thông số parameters trên HEADER để quyết đinh location directive nào xử lý tiếp. (location directive block nằm trong server directive).

Nếu ta có nhiều config location khác nhau, ví dụ như:

```
server {
    location / {
        root /data/www;
    }

    location /images/ {
        root /data;
    }
}
```

Thì NGINX sẽ kiểm tra URI và lấy location match với URI dài nhất, nghĩa là đường dẫn URL rõ hơn. (giống CSS selector :D)

Ta có thể xem log của NGINX để biết được việc access cũng như error trong quá trình config reload bị lỗi, hoặc kiểm tra access nếu có attacker.v.v.. Hai file log là access.log và error.log nằm ở thư mục /var/log/nginx hoặc là /usr/local/nginx/logs.

3. Việc set-up một proxy server với NGINX

Proxy server: server có nhiệm vụ tiếp nhận requests rồi truyền đến một server khác để lấy thông tin response rồi sau đó gửi ngược lại về cho phía client. Proxy server như là trạm chung truyển giữa client và server đích.

Ví dụ ta có 2 con server, 1 server đích (proxied server) và 1 server trung chuyển (proxy server).

Cấu hình proxied server:

```
server {
    listen 8080;
    root /data/up1;

    location / {
    }
}
```

Cấu hình proxy server:

```
server {
    location / {
        proxy_pass http://localhost:8080;
    }

    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```

Đối với proxy server, ta dùng directive proxy_pass với protocol, name và port của server đích (proxied server). Có 2 điểm để nói ở đây, 1 là những request mà kết thúc bằng những image type như trên (gif, jpg, png) sẽ được phục vụ tại server proxy thông qua thư mục tĩnh /data/images.

NGINX sử dụng `~` để biểu thị khả năng matching bằng REGEX của nó.

Ý thứ 2 là những request còn lại sẽ được pass qua server đích (location:8080 proxied server).



4. Cài đặt FastCGI proxing

NGINX có thể được sử dụng để điều hướng đến FastCGI server, là server chạy những ứng dụng viết bằng những framework PHP.

Ví dụ:

```
server {
    location / {
        fastcgi_pass  localhost:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param QUERY_STRING    $query_string;
    }

    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```

NGINX sẽ dùng fastcgi_pass directive thay thế cho proxy_pass, và sử dụng fastcgi_param để truyền param script_filename và query_string. Giao thức kết nối giữa 2 server là FastCGI protocol.

[Tobe continue...]


