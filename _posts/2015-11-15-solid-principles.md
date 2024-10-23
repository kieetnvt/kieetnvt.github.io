---
layout: post
title: SOLID fundamental principles (Vietnamese version)
subtitle: SOLID fundamental principles
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/solid.png
share-img: /assets/img/path.jpg
tags: [ruby, vietnamese]
author: kieetnvt
---

![SOLID fundamental principles](/assets/img/solid.png)

SOLID là một thuật ngữ gồm 5 nguyên tắc căn bản về việc maintain code của chúng ta trong bất kỳ ngôn ngữ hay phương pháp lập trình nào.

SOLID là nền tảng để chúng ta có thể đánh giá chất lượng và kiến trúc của codebase của hệ thống.

SOLID là viết tắt của 5 nguyên tắc sau:

* S - Single Responsibility Principle (Trách nhiệm đơn)

* O - Open/Close Principle (Nguyên tắc mở và đóng)

* L - Liskov Substitution Principle (Nguyên tắc thay thế của Liskov)

* I - Interface Segregation Principle (Nguyên tắc tách riêng các giao diện interface)

* D - Dependency Inversion Principle (Nguyên tắc về sự phụ thuộc ngược)


__1. S - Single Responsibility Principle (Trách nhiệm đơn)__

S: Single Responsibility Principle (SRP) là một trong những nguyên tắc cơ bản của lập trình dựa trên nhiệm vụ, chỉ đảm nhiệm 1 chức năng, không ôm đồm nhiều thứ ---> giữ cho classes và methods nhỏ gọn dễ maintain và dễ hiểu.

Tuy nhiên, cũng khó để xác định trách nhiệm của từng class, module hoặc method. Đối với dự án nhỏ thì không nói, còn dự án lớn lớn tí, có nhiều logic tính toán các kiểu thì khó xác định trách nhiệm của chúng vì chúng dễ chồng lấn lên nhau. Ví dụ cơ bản:

~~~
class DealProcessor
  def initialize(deals)
    @deals = deals
  end

  def process
    @deals.each do |deal|
      Commission.create(deal: deal, amount: calculate_commission)
      mark_deal_processed
    end
  end

  private

    def mark_deal_processed
      @deal.processed = true
      @deal.save!
    end

    def calculate_commission
      @deal.dollar_amount * 0.05
    end
end
~~~

`Commission`: hoa hồng. `Commission` là một class service tính toán, `calculate_commission` là method liên quan tới `Commission` trách nhiệm không thuộc về `DealProcessor` nên cần chuyển method này sang class service `Commission`. Ví dụ sau:

~~~
class DealProcessor
  def initialize(deals)
    @deals = deals
  end

  def process
    @deals.each do |deal|
      mark_deal_processed
      CommissionCalculator.new.create_commission(deal)
    end
  end

  private

    def mark_deal_processed
      @deal.processed = true
      @deal.save!
    end
end

class CommissionCalculator
  def create_commission(deal)
    Commission.create(deal: deal, amount: deal.dollar_amount * 0.05)
  end
end
~~~

Mỗi class sẽ đảm nhiệm chức năng riêng, việc phân chia còn tùy thuộc vào bussiness logic của project, hay tùy thuộc vào code base structure của leader.

__2. O - Open/Close Principle (Nguyên tắc mở và đóng)__

Nguyên tắc đóng mở ? #mớinghe ~~!
Nguyên tắc nói là classes hay methods nên được mở kiểu extension nhưng không được modify ngược, kiểu như là ta có 1 class chuẩn rồi, nên gói lại, ai muốn dùng thì thừa kế lại, không được modify ngược lại class đó. Ví dụ:

~~~
class UsageFileParser
  def initialize(client, usage_file)
    @client = client
    @usage_file = usage_file
  end

  def parse
    case @client.usage_file_format
      when :xml
        parse_xml
      when :csv
        parse_csv
    end

    @client.last_parse = Time.now
    @client.save!
  end

  private

    def parse_xml
      # parse xml
    end

    def parse_csv
      # parse csv
    end
end
~~~

Code trên khá bất tiện, vì ta có nhiều thể loại file (xml, csv, xlsx, tsv, dat,..) mỗi loại file có cách parser khác nhau, mà nếu viết như trên thì phải if else nhiều lần trong hàm parser của class ---> mỗi lần có file type mới lại phải modify class này, tốn chi phí test lại, mà code thì ngày càng dài ngoằng, if else nhiều thì chuối lắm. Refactor như sau:

{%highlight ruby%}
class UsageFileParser
  def initialize(client, parser)
    @client = client
    @parser = parser
  end

  def parse(usage_file)
    parser.parse(usage_file)
    @client.last_parse = Time.now
    @client.save!
  end
end

class XmlParser < UsageFileParser
  def parse(usage_file)
    # parse xml
  end
end

class CsvParser < UsageFileParser
  def parse(usage_file)
    # parse csv
  end
end
{%endhighlight%}

__3. L - Liskov Substitution Principle (Nguyên tắc thay thế của Liskov)__


Cái nguyên tắc ngày khó để hiểu, và mình cũng mới nghe ~~!
Nó nói là chúng ta nên thay thế các instances của class cha bằng một instance của một trong những class con và không tạo thêm bất kì hành động nào. Là sao? Ví dụ sau có thể rõ hơn:

{%highlight ruby%}
class Rectangle
  def set_height(height)
    @height = height
  end

  def set_width(width)
    @width = width
  end
end

class Square < Rectangle
  def set_height(height)
    super(height)
    @width = height
  end

  def set_width(width)
    super(width)
    @height = width
  end
end
{%endhighlight%}

Cái ví dụ trên đã vi phạm nguyên tắc vì đối với class con là `Square` việc gọi hàm `set_height` override method `set_height` của class cha, và hàm này đã modify cả 2 biến instance của class cha, không đúng với ý nghĩa và mục đích sử dụng.

__4. I - Interface Segregation Principle (Nguyên tắc tách riêng các interface)__

Cái này hiểu đơn giản gần giống với nguyên tắc trách nhiệm đơn về mặt ý nghĩa. Chúng ta nền tách riêng interface (class) tùy theo thực thể entity. Như ví dụ sau:

{%highlight ruby%}
protocol QuestionAnswering {
  var questions: [Question] { get }
  func answerQuestion(questionNumber: Int, choice: Int)
}

class Test: QuestionAnswering {
  let questions: [Question]
  init(testQuestions: [Question]) {
    self.questions = testQuestions
  }

  func answerQuestion(questionNumber: Int, choice: Int) {
    questions[questionNumber].answer(choice)
  }

  func gradeQuestion(questionNumber: Int, correct: Bool) {
    question[questionNumber].grade(correct)
  }
}

class User {
  func takeTest(test: QuestionAnswering) {
    for question in test.questions {
      test.answerQuestion(question.number, arc4random(4))
    }
  }
}
{%endhighlight%}

__5. D - Dependency Inversion Principle (Nguyên tắc về sự phụ thuộc ngược)__

The Dependency Inversion Principle has to do with high-level (think business logic) objects not depending on low-level (think database querying and IO) implementation details. This can be achieved with duck typing and the Dependency Inversion Principle. Often this pattern is used to achieve the Open/Closed Principle that we discussed above. In fact, we can even reuse that same example as a demonstration of this principle. Let’s take a look:

Nguyên tắc này nói rằng là một object tầng cao (logic bussiness) thì không nên dựa trên những object tầng thấp hơn (database query, IO..).

{%highlight ruby%}
class UsageFileParser
  def initialize(client, parser)
    @client = client
    @parser = parser
  end

  def parse(usage_file)
    parser.parse(usage_file)
    @client.last_parse = Time.now
    @client.save!
  end
end

class XmlParser
  def parse(usage_file)
    # parse xml
  end
end

class CsvParser
  def parse(usage_file)
    # parse csv
  end
end
{%endhighlight%}

Follow by [Back to Basics: SOLID](https://robots.thoughtbot.com/back-to-basics-solid)
