---
layout: post
title: "Intro gems: Searchkick, Pundit, Rolify and Draper (Vietnamese version)"
subtitle: "Intro gems: Searchkick, Pundit, Rolify and Draper"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby, vietnamese]
author: kieetnvt
---

![gems collection](/images/gems-collection.jpg)

> Dưới đây là một số ```Gem``` mà tôi thường sử dụng trong ```Ruby On Rails```, đối với tôi thì những ```Gem``` này khá hay, tiện lợi, dễ dùng và giúp cho việc phát triển Web dễ dàng hơn rất nhiều. Có thể tôi sẽ bỏ qua 1 số thông thường về database.

# [SearchKick](https://github.com/ankane/searchkick)

SearchKick là 1 gem dùng cho việc tìm kiếm, ngoài việc tìm kiếm thông thường, nó còn hỗ trợ stemming, special characters, extra whitespace, custom synonyms. Hơn thế nữa, làm việc và cài đặt môi trường cho SearchKick rất dễ dàng, không rườm rà như Solr Lucene

1. câu query giống ngôn ngữ SQL -> chẳng cần phải học thêm 1 ngôn ngữ truy vấn mới.
2. đánh index lại với database => __No Downtime__.
3. dễ chỉnh sửa kết quả trả về tùy mỗi người.
4. autocomplete.
5. tự đưa ra gợi ý suggesstion cho câu query (like Google :D)
6. làm việc tốt với __ActiveRecord__ (Sql Database), __Mongoid__ (Mongodb)

**Cách cài đặt và sử dụng:**

1. cài đặt __Elasticseach__, Searchkick được sử dụng như 1 cây cầu nối giữa Database và một Search engine đế đánh chỉ mục (Elasticsearch), và việc truy vấn sau này sẽ thông qua Elasticsearch, không truy vấn vào DB nữa.
2. tất nhiên phải có dòng ```gem 'searchkick'``` trong ```Gemfile``` rồi.
3. thêm searchkick vào model nào mà bạn muốn đánh chỉ mục model đó

```ruby
class Product < ActiveRecord::Base
  searchkick
end
```

4. khi bắt đầu thì điều cần thiết là phải đánh index cho model ví dụ: ```Product.reindex```
5. sử dụng truy vấn đơn giản như sau:

```ruby
products = Product.search "apples"
products.each do |product|
  puts product.name
end
```

***

# [Devise](https://github.com/plataformatec/devise)

Devise là một gem không thê thiếu cho ứng dụng có xác thực người dùng, các tính năng chính của Devise như sau:

1. __Database Authenticable__ : encrypts và stores password.
2. __Omniauthable__ : multi-provider - đăng nhập thông qua bên thứ 3.
3. __Confirmable__  : gửi email xác thực tài khoản.
4. __Recoverable__  : reset mật khẩu, và thông tin cá nhân.
5. __Registerable__ : đăng kí tài khoản
6. __Rememberable__ : khởi tạo( cũng như là xóa ) cookie đăng nhập từ user.
7. __Trackable__  : lưu vết của người dùng khi đăng nhập (như IP, số lượng, thời gian.)
8. __Timeoutable__  : làm hết hạn đăng nhập trong khoảng thời gian.
9. __Validatable__  : chức năng kiểm tra email, mật khẩu.
10. __Lockable__  : khóa tài khoản sau số lần đăng nhập fail, mở lại tài khoản bằng cách gửi email xác nhận hoặc sau khoảng thời gian nhất định.

***

# [Pundit](https://github.com/elabs/pundit)

Là 1 tập hợp các helpers giúp ta có thể authorize classes hoặc 1 object dựa trên Policies tương ứng với Model.

Sẽ hiểu rõ hơn thông qua đoạn code:

Trong Controller:

```ruby
# in app/controllers/post_controller.rb
def update
  @post = Post.find(params[:id])
  authorize @post
  @post.update(post_params) ? redirect_to @posts : render :edit
end
# in app/policies/post_policy.rb
def update?
  user.admin? or not record.published?
end
```
authorize @post: Pundit sẽ tự động tìm đến class PostPolicy và check hàm update? xem có được thực thi tiếp hay không?

Nôm na là vậy, cụ thể hơn thì vào gem pundit mà coi nó đã làm gì :D

***

# [Rolify](https://github.com/RolifyCommunity/rolify)

Rolify là một thư viện để check xem user có quyền làm việc gì hay không?, gem này sẽ tạo ra table Role để save new role và query check user có quyền nào đó. Nó cho phép ta set role cho user cho Model, cho Row dữ liệu, cho 1 object, 1 thực thể cụ thể liên quan đến database. (Instance level, Class level and in Strict Mode)

một vài ví dụ lấy từ docs của Rolify:

```ruby
forum = Forum.first
forum.roles
# => [ list of roles that are only binded to forum instance ]
forum.applied_roles
# => [ list of roles binded to forum instance and to the Forum class ]

Forum.with_role(:admin)
# => [ list of Forum instances that has role "admin" binded to it ]

class User < ActiveRecord::Base
  rolify strict: true
end
@user = User.first
@user.add_role(:forum, Forum)
@user.add_role(:forum, Forum.first)
@user.has_role?(:forum, Forum) #=> true
@user.has_role?(:forum, Forum.first) #=> true
@user.has_role?(:forum, Forum.last) #=> false
```
***

# [Draper](https://github.com/drapergem/draper)

Thường được sử dụng trên View (nhưng có thể dùng cả trong Controller), kiểu như helper, được cái nó giúp code structure theo kiểu ÔÔP, helper ứng với Class object, wrap model phục vụ cho việc diễn ta logic trong model, và hỗ trợ cho Test tốt hơn.

Draper có rất nhiều ứng dụng đối với rails app, xem và ứng dụng vào app của mình tại document của draper, nó rất rõ ràng cho bạn.
