---
layout: post
title: Rails ActiveRecord Associations
subtitle: Rails ActiveRecord Associations
cover-img: "/assets/img/path.jpg"
thumbnail-img: "/assets/img/ruby.jpg"
share-img: "/assets/img/path.jpg"
tags:
- ruby
- rails
author: kieetnvt
lang: vi
ref: rails-active-record-associations
---

> Ôn tập active record query

Các loại association?

Có 6 loại association: `belongs_to`, `has_one`, `has_many`, `has_many :through`, `has_one :through`, `has_and_belongs_to_many`.

`belongs_to` phải sử dụng ở dạng số ít, nó mô tả mối quan hệ one-to-one. Ví dụ: `1 Order` thuộc về `1 Customer`
trong model Order có tên field là `customer_id` (int), và `customer_id` tham chiếu đến id của model Customer.

`has_one` được xây dựng cho mối quan hệ one-to-one, nó thiết lập kết nối giữa 2 models, nhưng nó có ngữ nghĩa khác một chút.
Ví dụ mỗi Supplier có một Account, trong model Account có tên field là `supplier_id`(int).

`belongs_to` và `has_one` giống nhau khi chúng ta viết migrations, chúng ta cần indexing column kết nối (`customer_id`, `supplier_id`)

`has_many` chỉ ra mối quan hệ one-to-many. Ví dụ: `1 Customers` có nhiều `n orders`. Instance của model Customer có nhiều instance của model orders.
Ví dụ: Customer có nhiều orders. trong model Order có field `customer_id`(int)

Ví dụ migration:

~~~
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :orders do |t|
      t.belongs_to :customer, index: true
      t.datetime :order_date
      t.timestamps null: false
    end
  end
end
~~~

Association `has_many :through`. Nó thường được sử dụng để thiết lập kết nối many-to-many. Nó chỉ ra rằng một model có thể được khớp với nhiều instance của model khác `through` model thứ ba.
Ví dụ: xem xét ngữ cảnh về thực hành y tế, nơi bệnh nhân đặt lịch hẹn để gặp bác sĩ. 1 Physician có thể có nhiều patients thông qua appointments. Physician có nhiều patients và có nhiều appointments. Sau đó, appointments thuộc về physician, và thuộc về appointment. Giống như physicians, 1 Patient có thể có nhiều physicians thông qua appointments. Patient có nhiều physicians, có nhiều appointments.
Model Appointments có 2 field để mô tả kết nối là `physician_id` và `patient_id`.

Ví dụ:

~~~
class Physician < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
end

class Appointment < ActiveRecord::Base
  belongs_to :physician
  belongs_to :patient
end

class Patient < ActiveRecord::Base
  has_many :appointments
  has_many :physicians, through: :appointments
end
~~~

Một số khi `has_many :through` sử dụng như `shortcuts`, ví dụ chúng ta có Document, document có nhiều sections, một session có nhiều paragraphs. Vậy chúng ta có thể lấy paragraphs của documents bằng Document.paragraphs thông qua association này.

~~~
class Document < ActiveRecord::Base
  has_many :sections
  has_many :paragraphs, through: :sections
end

class Section < ActiveRecord::Base
  belongs_to :document
  has_many :paragraphs
end

class Paragraph < ActiveRecord::Base
  belongs_to :section
end
~~~

Association `has_one :through`. Giống như `has_many :through`, nó chỉ ra kết nối thông qua model thứ ba, nhưng nó có một kết nối.

Association `has_and_belongs_to_many`, chỉ ra kết nối many-to-many, không có model trung gian.

Ví dụ: tạo model Assembly và model Part, mỗi assembly có nhiều parts, và mỗi part có nhiều assemblies. Nhưng chúng ta không cần tạo model trung gian như assembly_part.

~~~
class Assembly < ActiveRecord::Base
  has_and_belongs_to_many :parts
end

class Part < ActiveRecord::Base
  has_and_belongs_to_many :assemblies
end

class CreateAssembliesAndParts < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :parts do |t|
      t.string :part_number
      t.timestamps null: false
    end

    create_table :assemblies_parts, id: false do |t|
      t.belongs_to :assembly, index: true
      t.belongs_to :part, index: true
    end
  end
end
~~~

> Polymorphic Associations

Với polymorphic assocation, một model có thể thuộc về nhiều hơn một model, trên một association duy nhất. Bạn có thể nghĩ `polymorphic belongs_to` là việc thiết lập `interface` mà bất kỳ model nào khác có thể sử dụng.

Ví dụ: bạn có model picture, thuộc về hoặc là model employee hoặc model product.

~~~
class Picture < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
end

class Employee < ActiveRecord::Base
  has_many :pictures, as: :imageable
end

class Product < ActiveRecord::Base
  has_many :pictures, as: :imageable
end
~~~

Bạn có thể lấy pictures bằng `@employee.pictures` và `@product.pictures`.
Bạn có thể lấy parent của picture bằng `@picture.imageable`, bạn có thể khai báo cả foreign key column và type column trong model khai báo polymorphic interface.

~~~
class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.integer :imageable_id
      t.string :imageable_type
      t.timestamps null: false
    end

    add_index :pictures, :imageable_id
  end
end

// migration này có thể được đơn giản hóa bằng t.references từ

class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.references :imageable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
~~~

> Self Joins

Một số khi, bạn sẽ tìm thấy một model có mối quan hệ với chính nó. Ví dụ, bạn muốn lưu trữ tất cả `employees` trong một model duy nhất, nhưng bạn muốn biết ai là manager hoặc ai là subordinates. Nó có nghĩa là bạn có thể trace mối quan hệ giữa manager và subordinates.

~~~
class Employee < ActiveRecord::Base
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
  belongs_to :manager, class_name: "Employee"
end
// Với thiết lập này bạn có thể lấy, @employee.manager và @employee.subordinates

// Trong migration
class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :manager, index: true
      t.timestamps null: false
    end
  end
end
~~~

