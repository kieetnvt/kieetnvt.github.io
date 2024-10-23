---
layout: post
title: "Service Objects in Rails (Vietnamese version)"
subtitle: "Service Objects in Rails"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby, vietnamese]
author: kieetnvt
---


Nếu bạn đã biết về Rails Framework thì hản bạn đã biết về cấu trúc MVC của nó, với các directories đã được định nghĩa sẵn như Controller, Model và View. Đối với ứng dụng nhỏ, cấu trúc trên đã đủ tốt. Nhưng mà khi ứng dụng phát triển lên, khách hàng yêu cầu ngày càng nhiều tính năng thì có đôi lúc người lập trình viên không biết nên viết đoạn code ở đâu là hợp lý, là dễ dàng cho tìm kiếm và maintain chúng.

Ví dụ ở đây, tôi nói đến những bussiness logic. Đơn thuần những logic này ta không biết đặt đâu để có thể dễ dàng thay đổi khi yêu cầu thay đổi.

Trong hoàn cảnh này, phát triển logic trong các `service objects` là một trong những ý tưởng tốt. Nó giúp ta tách ra khỏi các Model - vốn model là làm việc với CRUD của DB.

> Keeping your classes small and maintainable with Service Objects.

## Explain an Example

Giả định bạn đang làm dự án đặt vé máy bay bằng Rails.

Và khách hàng yêu cầu như sau: "Sau khi user đặt vé thành công, anh ấy sẽ nhận được vé thông qua email."

Bạn: "Ok chắn chắn rồi, điều đó không là vấn đề, đơn giản thôi."

Và bạn sẽ làm tương tự như sau:

~~~
# app/controllers/ticket_controller.rb
# create
if @ticket.save
  Email.send_email_to_user(current_user.email, @ticket)
  # code
else
  # code
end
~~~

Khách hàng cảm thấy vui vẻ trong lúc này.

Một ngày đẹp trời, khách hàng yêu cầu: "Và đồng thời nhận vé thông qua điện thoại nếu họ có số điện thoại."

Và có 2 lựa chọn đối với bạn hiện tại:

Một là thêm điều kiện bên trong controller, điều này sẽ làm cho controller ngày một to ra. Fat controller.

Hai là tách ra 1 function và move code send email và send mobile vào function đó, function này được đặt ở model User.

~~~
# app/models/user.rb
  class User < ActiveRecord::Base
    # code

    # this method is called from the controller
    def send_notifications(ticket)
      Email.send_email_to_user(self.email, ticket)
      Sms.send(self.mobile, ticket) if self.mobile
    end
  end
~~~

You've saved the day!

Nhưng có một số vấn đề:

Một là, mặc dù function này có nhiệm vụ gửi đến cho user, nhưng nó không phải là nhiệm vụ chính của class User.

Hai là, thêm bussiness logic vào trong model User sẽ làm cho model ngày càng phình ra, rất khó trong việc maintain và testing.

Ba là, Việc testing model sẽ khó hơn khi phải cần điều kiện ngoại lai, cần điều kiện đủ, có thể là cần dữ liệu liên quan từ các model khác, vì một logic có thể liên quan đến nhiều thực thể khác nhau.

## Let build Service Object

Mặc dù Rails mang đến cấu trúc mặc định, nhưng không có ràng buộc nào ngăn cản ta thêm thư mục mới.

Tạo thư mục services

![Services Folder](http://i.imgur.com/gHQtrsr.png)

Và cho Rails biết mà load nó lên bằng `config.autoload_paths` trong `config/application.rb`

~~~
# config/application.rb
module <Rails Application Name>
  class Application < Rails::Application
    # code
    config.autoload_paths << Rails.root.join('services')
    # code
  end
end
~~~

Sau đây là ví dụ về implement service

~~~
# Sending notifications to users after a ticket has been purchased
class UserNotificationService
  def initialize(user)
    @user = user
  end

  # send notifications
  def notify(ticket)
    Email.send_email_to_user(@user.email, ticket)
    Sms.send(@user.mobile, ticket) if @user.mobile
  end
end
~~~

Và sau này chúng ta có thể thêm xóa logic nếu có sự thay đổi. Và không ảnh hưởng đụng chạm gì tới model User.

Cố gắng đề cho model thực hiện đúng chức năng của nó.

~~~
 # app/controllers/tickets_controller.rb #create

   if @ticket.save
     UserNotificationService.new(current_user).notify(@ticket)
     # code
   else
     # code
   end
~~~

## How about testing service object

![service object testing](http://i.imgur.com/wBnfAIC.png)

Và code test ví dụ, dùng Rspec

~~~
require 'rails_helper'

describe UserNotificationService do
  let(:user) { FactoryGirl.create(:user, mobile: mobile) }
  let(:ticket) { FactoryGirl.create(:ticket) }

  subject(:notification) do
    UserNotificationService.new(user).notify(ticket)
  end

  context 'when the user does not have a mobile number' do
    let(:mobile) { nil }

    it 'send an email' do
      expect(Email).to receive(:send_email_to_user)
      notification
    end

    it 'does not send an SMS' do
      expect(Sms).to_not receive(:send)
      notification
    end
  end
end
~~~

Implementing a service is not too hard, right?

Happy Coding!

