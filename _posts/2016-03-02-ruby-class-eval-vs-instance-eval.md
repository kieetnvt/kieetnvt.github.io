---
layout: post
title: "Ruby Class Eval vs Instance Eval (Vietnamese version)"
subtitle: "Ruby Class Eval vs Instance Eval"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby, rails]
author: kieetnvt
---

> Different point between `class_eval` and `instance_eval`

```ruby
class Person
end

Person.class_eval do
  def say_hello
   "Hello!"
  end
end

jimmy = Person.new
jimmy.say_hello # "Hello!"
```

Trong ví dụ ở trên thì, `class_eval` cho phép ta định nghĩa method bên ngoài class Person, tất nhiên chúng ta không mở lại class Person.

Class Person không biết method say_hello cho tới khi nó runtime. -> `metaprogramming` code sinh ra code là đây

Trường hợp khác, ta có ví dụ sau:

```ruby
class Person
end

Person.instance_eval do
  def human?
    true
  end
end

Person.human? # true
```

Trong ví dụ trên thì `instance_eval` cũng hoạt động giống `class_eval` nhưng khác biệt ở chỗ là môi trường của biến instance đang đứng (context).

Nó gây ra sự bối rối nhất định.

Ví dụ 1, `class_eval` tạo ra instance_methods còn ví dụ 2 `instance_eval` tạo ra class_methods.

Bởi vì, `class_eval` là 1 method của class `Module`, nghĩa là receiver sẽ là 1 module hoặc là 1 class. Block mà ta pass phía sau `class_eval` sẽ được thực thi trong context của class đó. Cho nên khi ta định nghĩa method với `def` trong block này nghĩa là định nghĩa method inside class nên nó trở thành instance_methods trong class này.

Mặt khác, `instance_eval` là 1 method của class `Object`, nghĩa là recevier là 1 object. Block mà ta pass sau `instance_eval` sẽ được thực thi trong context của object đó. ví dụ là  `Person.instance_eval` được thực thi trong ngữ cảnh của `Person` object. Và nên nhớ rằng tên của class là 1 class object và define method trong context Class sẽ tạo ra `class_methods`.

Tóm lại đơn giản: MyClass.class_eval thì tạo instance_methods còn  MyClass.instance_eval thì tạo ra class_methods.

Done!

