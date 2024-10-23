---
layout: post
title: "Well grounded ruby object"
subtitle: "Well grounded ruby object"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby, rails]
author: kieetnvt
---

> Ruby come to an idea of `manipulating data through object called by *object orientation*`

 1. Defining Object behaviors:

```ruby
def obj.talk
  puts "I'm a Object"
end
```

 2. Sending message to Object:

  `obj.talk` the dot(.) is the message-sending operator. the `message` on right is sent to obj (obj called `receiver`) on the left.

> Everything in ruby is object, Every behavior is a method call.

 `obj.talk` is in real world is `obj.send(:talk)` *send* is a message-sending operator.

 send method can call the *private method of class* in public!!!.

```ruby
def obj.listen
end
```

 We can define methods of obj, only belongs to specific obj. The method not store in class of obj, also not store in storge space of obj, the obj only refer to storge space, the method store in the *Singleton Class of obj* and it is a ancester relation (child) with Class super of obj.

 3. String VS Symbol

 Symbol example: `:symbol`, `:"here is a symbol"`
 Use `to_sym` method

 Symbol is immutable (don't append other thing into :symbol)

 Symbol is uniqueness (`:symbol` always has 1, only 1, object_id, use object_id method to know same objects)

 String is not uniqueness (`"abc"` always has diffenrent object when call)

 `s = :x` => :x is symbol object, s is local variable identifier.

 `"abc".send(:upcase)` and `"abc".send("upcase")` will work. An extra step is taken (to_sym called) for "upcase".to_sym.

 Symbol in ruby Hash as Keys, you also use String as hash keys.

 Ruby hash looking good better in Symbol than String

 We have 2 type of data: (String and others) and (Numeric: Float, Integer, Fixnum, Bignum)

> Some ruby questions

1. Precendence

```ruby
val1 = true and false
val2 = true && false
```

=> This question about Precedence. `and or` have lower precedence than `=`. `&& ||` have higher precedence than `=`

```ruby
(val1 = true) and false
val2 = (true && false)
```

2. False or True

```ruby
true    ? "true" : "false"
false   ? "true" : "false"
nil     ? "true" : "false"
1       ? "true" : "false"
0       ? "true" : "false"
"false" ? "true" : "false"
""      ? "true" : "false"
[]      ? "true" : "false"
```

=> `false` `nil` evaluate to false. Everything else even Zero or emty array evaluates to true.

3. Write function sort the keys of hash by the length of keys.

```ruby
hash.keys.map(&:to_s).sort_by(&:length)
```

4. Difference `super` and `super()`

`super` invoke the parent method with the same arguments pass in the child method if don't match raise error.

`super()` invoke the parent method without any arguments

