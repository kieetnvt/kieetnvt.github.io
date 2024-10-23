---
layout: post
title: "Rails Model Refactoring"
subtitle: "Rails Model Refactoring"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby, rails]
author: kieetnvt
---

> Keep healthy and reduce responsibility of ActiveRecord models

# Presenters

Presenters pattern may be more commonly known as the View-Model pattern.

The idea is we want to seperate the code related with presenting and displaying attribute of instance model in View. View != Model. The Model only contains logic code, don't need to contain code related with View.

We call it a `Presenter`, it's just a class represent displaying logic from Model to View.
Presenters can solve problem:
 - too much logic code in Views
 - large size helpers
 - models has view code

## Presenters implementation
~~~
# defind User model class
class User < ActiveRecord::Base
  attr_accessible :last_name, :first_name
end

# define presenter file, app/views/presenters/user.rb
require 'delegate'
class UserPresenter < SimpleDelegator
  def full_name
    "My name is #{model.first_name} #{model.last_name}"
  end
  def model
    __getobj__
  end
end

# in controller
@user = UserPresenter.new(User.new(first_name: "tuan", last_name: "kiet")
# in view
@user.full_name
~~~

# Concerns

Concerns help reduce logic write in models, remove duplicate function accross models, also grouping code relate of logic together.
assume, we have two model which have same methods serve same logic, we can move this code into models/concerns/

~~~
class Blog < ActiveRecord::Bas
  def long_date
    date.strftime("%Y/%M/%d")
  end
end
class Comment < ActiveRecord::Base
  def long_date
    date.strftime("%Y/%M/%d")
  end
end

# move long_date into concerns
# app/models/concerns/date_formatable.rb
module Concerns::DateFormattable
  def long_date
    date.strftime("%Y/%M/%d")
  end
end

# inside models we must include Concerns::DateFormattable
class Blog < ActiveRecord::Bas
  include Concerns::DateFormattable
end
class Comment < ActiveRecord::Bas
  include Concerns::DateFormattable
end
~~~

# Services

Services are Rails pattern with the aim to keep logic in Controller clearly, can put the logic bussiness in one place, help refactor and testing easier and better.
Assume, if you have the logic "after user create successfully, the app sent email confirm and notify for admin known". So we can create the service class to do job sent email and notify, and in controller you only need call action create user.

~~~
class UserController < ApplicationController
  def create
    @event = UserEventCreate.new.exec(user_params)
  end
end

class UserEventCreate
  def exec(user_params)
    user = User.create(user_params)
    if user.valid?
      send_email_confirm(user)
      notify_admin(user)
    end
  end

  def send_email_confirm(user)
    EventMailer.notify(user).deliver
  end

  def notify_admin(user)
    EventMailer.notify_admin(user).deliver)
  end
end
~~~

