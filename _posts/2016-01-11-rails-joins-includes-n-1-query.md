---
layout: post
title: "Joining tables, Eager loading and Solve N + 1 query!"
subtitle: "Joining tables, Eager loading and Solve N + 1 query!"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [ruby, rails]
author: kieetnvt
---

> Summary joining tables in rails

# Joinings Tables

We have many ways to use `joins` in Rails.

1. Using string SQL Fragment
 - problem with this way is SQL injection

   Example:

   `Client.joins('LEFT OUTER JOIN addresses ON addresses.client_id = clients.id')`

2. Using array / hash of named associtions
 - this way ONLY work with `INNER JOIN`
 - we using `joins` keyword with associtions of rails
 - join nested and multiple associtions

    Example:

    - return all category objects with articles

    `Category.joins(:articles)`

    SELECT * from categories INNER JOIN articles ON articles.category_id == categories.id

    - return all articles that have category and at least one comment

    `Articles.joins(:category, :comments)` _join multiple_

    SELECT * from articles INNER JOIN categories ON categories.id == articles.category_id INNER JOIN comments ON comments.article_id == articles.id

    - return all articles that have comment made by guest

    `Articles.joins(comments: :guest)` _join nested single level_

    SELECT * from articles INNER JOIN comments ON comments.article_id == articles.id INNER JOIN guests ON guests.comment_id == comments.id

    - return all categories with articles which comment made by guest and at least has one tag

    `Category.joins(articles: [{ comments: :guest }, :tags ])` _join nested multiple level_

    SELECT * from categories INNER JOIN articles ON articles.category_id == categories.id INNER JOIN comments ON comments.article_id == articles.id INNER JOIN guests ON guests.comment_id == comments.id INNER JOIN tags ON tags.article_id == articles.id

3. Specifying conditions on the Joined tables
 - Hash conditions

   Example:

   `Client.joins(:orders).where(order: {created_at: time_range})`

# Eager loading

> `INCLUDES` methods solve the N+1 queries and Eager loading in Rails

The N+1 problem

~~~
clients = Client.limit(10)
 
clients.each do |client|
  puts client.address.postcode
end

# solve

clients = Client.includes(:address).limit(10)

clients.each do |client|
  puts client.address.postcode
end


# the query
# SELECT * FROM clients LIMIT 10 SELECT addresses.* FROM addresses WHERE (addresses.client_id IN (1,2,3,4,5,6,7,8,9,10))
~~~

- Eager loading mutiple associtions

`Article.includes(:category, :comments)`

- Nested associtions hash

`Category.includes(articles: [{ comments: :guest }, :tags]).find(1) }])`

- Specific condition on eager loading

`Article.includes(:comments).where(comments: { visible: true }) })`

- Specific condition on eager loading with SQL Fragment, we use `:references`

`Article.includes(:comments).where("comments.visible = true").references(:comments)`

# Different

in the case use `includes` query, if there were no comments for any articles, all aritcles would still loaded in RAM.

in the case use `joins` (INNER JOIN), the join condition must match, otherwise no records will be returned.

