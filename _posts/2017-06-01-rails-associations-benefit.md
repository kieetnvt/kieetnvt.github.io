---
layout: post
title: Rails Associations Benefit
subtitle: Rails Associations Benefit
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [rails associations]
author: kieetnvt
---

# Crying with Rails Associations

## Belongs To:

```
class Post < ApplicationRecord
  belongs_to :user
end

create_table :photos do |t|
  t.belongs_to :user, index: true
  t.timestamps
end
```

• Post table has field user_id
• Must use the singular term
• Reference:

```
association
association=(associate)
build_association(attributes = {})
create_association(attributes = {})
create_association!(attributes = {})
reload_association
```

• Options for belongs_to:

```
:autosave
:class_name
:counter_cache
:dependent
:foreign_key
:primary_key
:inverse_of
:polymorphic
:touch
:validate
:optional
```

## Autosave of Belongs To:

• Not set: If the :autosave option is not present, then new associated objects will be saved, but updated associated objects will not be saved.

```
# New associated objects will be saved
@post = Post.first;
@user1 = User.first;
@user2 = User.new(name: “new user”);
suppose: @post.user === @user1
@post.user = @user2 // new user
@post.save
=> will create @user2 - inserted on table user, and then set post belongs to this user

# But updated associated objects will not be saved
@post.user.name = “Updated name on new user”
@post.save
=> not save the new name of @user2.
```

• Autosave true:

- Rails will save any loaded association members and destroy members that are marked for destruction whenever you save the parent object

```
# Rails will save any loaded association members post = Post.find(1)
post.title       # => "The current global position of migrating ducks"
post.author.name # => "alloy"

post.title = "On the migration of ducks"
post.user.name = "Eloy Duran"

post.save
post.reload
post.title       # => "On the migration of ducks"
post.user.name # => "Eloy Duran"

# destroy members that are marked for destruction whenever you save the parent object post.user.mark_for_destruction
post.user.marked_for_destruction? # => true

post.save
=> will deleted the user (marked)
post.reload.user ==> nil
```

• Autosave false:

- Rails not save any loaded associations
- Not destroy members that are marked for destruction whenever you save the parent object

• When are Objects Saved?

- Assigning an object to a belongs_to association does not automatically save the object. It does not save the associated object either.

## Has One:

• Like belongs_to model & db
• class_name:

```
class Post < ApplicationRecord
  has_one :user, class_name: "Photo"
end
```

```
Post.first.user
Post Load (0.2ms)  SELECT  "posts".* FROM "posts" ORDER BY "posts"."id" ASC LIMIT $1  [["LIMIT", 1]]
Photo Load (5.8ms)  SELECT  "photos".* FROM "photos" WHERE "photos"."post_id" = $1 LIMIT $2  [["post_id", 1], ["LIMIT", 1]]

• When are Objects Saved?
• When you assign an object to a has_one association, that object is automatically saved (in order to update its foreign key). In addition, any object being replaced is also automatically saved, because its foreign key will change too.
• Set foreign_key of the old to NIL, update. foreign_key for to link user with new record.
• If either of these saves fails due to validation errors, then the assignment statement returns false and the assignment itself is cancelled.
•
• If the parent object (the one declaring the has_one association) is unsaved (that is, new_record? returns true) then the child objects are not saved. They will automatically when the parent object is saved.
•
• If you want to assign an object to a has_one association without saving the object, use the build_association method.

ser.post = Post.last
Post Load (0.8ms)  SELECT  "posts".* FROM "posts" ORDER BY "posts"."id" DESC LIMIT $1  [["LIMIT", 1]]
(0.3ms)  BEGIN
Post Update (0.6ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3  [["user_id", nil], ["updated_at", "2019-04-08 17:59:22.361712"], ["id", 1]]
Post Update (0.5ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3  [["user_id", 1], ["updated_at", "2019-04-08 17:59:22.365294"], ["id", 3]]
(1.7ms)  COMMIT
=> #<Post id: 3, user_id: 1, title: "test", created_at: "2019-04-08 17:59:12", updated_at: "2019-04-08 17:59:22">
2.5.3 :125 >
```

## Has Many

• @user.posts << @post:

- SAVE automatic Updated post with user_id
- user.posts << Post.find(4)
- UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3

• @user.posts.delete(@post):

- SAVE automatic, set user_id on post to NIL, NOT delete from DB on post.
- UPDATE "posts" SET "user_id" = NULL WHERE "posts"."user_id" = $1 AND "posts"."id" = $2

• @user.posts.destroy(@post):

- Running the destroy method on @post
- SAVE automatic  - delete post
- DELETE FROM "posts" WHERE "posts"."id" = $1  [["id", 4]]

• @user.posts = [Post.find(1), Post.find(2), Post.find(3)]:

- SAVE automatic
- Update post with set user_id for them
- Post Update (2.3ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3  ["id", 1]]
- Post Update (2.3ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3 ["id", 2]]
- Post Update (2.3ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3 ["id", 3]]

• @user.posts.clear:

- SAVE automatic
- method removes all objects from the collection according to the strategy specified by the dependent option.
- If no option is given, it follows the default strategy.
- The default strategy for has_many :through associations is delete_all, and for has_many associations is to set the foreign keys to NULL.

• @user.post_ids = [1,2,3]:

- SAVE automatic
- Update user_id reference to post with id 1,2,3
- Post Update (0.4ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3
- Post Update (0.4ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3
- Post Update (0.4ms)  UPDATE "posts" SET "user_id" = $1, "updated_at" = $2 WHERE "posts"."id" = $3

• @user.post_ids = [4,5,6]:

- SAVE automatic
- Post 1,2,3 ==> user_id set to NIL

• When are Objects Saved?

- When you assign an object to a has_many association, that object is automatically saved (in order to update its foreign key). If you assign multiple objects in one statement, then they are all saved.
- If any of these saves fails due to validation errors, then the assignment statement returns false and the assignment itself is cancelled.
- If the parent object (the one declaring the has_many association) is unsaved (that is, new_record? returns true) then the child objects are not saved when they are added. All unsaved members of the association will automatically be saved when the parent is saved.
- If you want to assign an object to a has_many association without saving the object, use the collection.build method.

## Has AND Belongs To Many

• When you assign an object to a has_and_belongs_to_many association, that object is automatically saved (in order to update the join table). If you assign multiple objects in one statement, then they are all saved.

• If any of these saves fails due to validation errors, then the assignment statement returns false and the assignment itself is cancelled.

• If the parent object (the one declaring the has_and_belongs_to_many association) is unsaved (that is, new_record? returns true) then the child objects are not saved when they are added. All unsaved members of the association will automatically be saved when the parent is saved.

• If you want to assign an object to a has_and_belongs_to_many association without saving the object, use the collection.build method.

## Association Callbacks:

Association callbacks are similar to normal callbacks,
but they are triggered by events in the life cycle of a collection. There are four available association callbacks:

```
before_add
after_add
before_remove
after_remove
```

