---
layout: post
title: "Rails ActiveRecord Associations"
subtitle: "Rails ActiveRecord Associations"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby, rails]
author: kieetnvt
---

> Review active record query

Types of association?

There are 6 types of association: `belongs_to`, `has_one`, `has_many`, `has_many :through`, `has_one :through`, `has_and_belongs_to_many`.

`belongs_to` must use in singular term, it describe one-to-one association. Example: `1 Order` belongs to `1 Customer`
in Order's model has field name `customer_id` (int), and `customer_id` referer with id of Customer's model.

`has_one` built for one-to-one association, it set-up connection between 2 models, but it has somewhat different semantics.
Example each Supplier has one Account, in Account's model has field name `supplier_id`(int).

`belongs_to` and `has_one` is same when we write migrations, we need to indexing the column connection (`customer_id`, `supplier_id`)

`has_many` is indicates one-to-many associations. Example: `1 Customers` has many `n orders`. Instance of Customer's model has many instance of orders's model.
Example: Customer has many orders. in Order's model has field `customer_id`(int)

Example migration:

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

The `has_many :through` association. it often use to set up many-to-many connection. It indicates One model can be matched with many instance other model `through` the third model.
Example: consider context about medical practice, where patients make appointments to see physicians. 1 Physician can has many patients through appointments. Physician has many patients and has many appointments. Then, appointments belongs to physician, and belongs to appointment. Like physicians, 1 Patient can has many physicians through appointments. Patient has many physicians, has many appointments.
Appointments model has 2 field bo describe the connection is `physician_id` and `patient_id`.

Example:

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

Sometime The `has_many :through` use like `shortcuts`, example we have Document, the document has many sections, one session has many paragraphs. So we can get paragraphs of ducuments by Document.paragraphs by this association.

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

The `has_one :through` association. Like `has_many :through`, it indicates connection through the third model, but it has one connection.

The `has_and_belongs_to_many` association, indicates many-to-many connection, with no intervaling model.

Example: create model Assembly and model Part, each assembly has many parts, and each part has many assemblies. But we don't need create model interval such as assembly_part.

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

With polymorphic assocation, one model can belongs to more then one model, on a single association. You can think a `polymorphic belongs_to` declare as setting up `interface` that any other model can use.

Example: you have picture model, that belongs to either an employee model or a product model.

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

You can retrive pictures by `@employee.pictures` and `@product.pictures`.
You can get parent of picture by `@picture.imageable`, you may declare both a foreign key column and type column in the model the declare the polymorphic interface.

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

// this migration can be simplified by t.references from

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

Sometime, you will find a model that should have a relation itself. Example, you want to store all `employees` in single model, but you want to know who is manager or who is subordinates. It mean you can trace relationship between manager and subordinates.

~~~
class Employee < ActiveRecord::Base
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
  belongs_to :manager, class_name: "Employee"
end
// With this set-up you can retrive, @employee.manager and @employee.subordinates

// In migration
class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :manager, index: true
      t.timestamps null: false
    end
  end
end
~~~

