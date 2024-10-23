---
layout: post
title: "The art of readable code: Pack information into your variables or functions name"
subtitle: "The art of readable code: Pack information into your variables or functions name"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/readablecode.jpg
share-img: /assets/img/path.jpg
tags: [nginx webserver]
author: kieetnvt
---


# Pack information into your variables or functions name

## I. Choose specific words, avoiding "empty" words.

Example: GetPage() => "Get" cannot show you the really meaning of behavior. "Get" is empty word, you donot know "The Page" is get from local or database or internet.

Solution: use DownloadPage(), or FetchPage() instead of GetPage().

## II. Finding more "colorful" words.

- English is a Rich language.
- Donot be afraid to use "colorful" words.

Example:

| Words         | Alternatives                            |
| ------------- | --------------------------------------- |
| send          | deliver, dispatch, announce, distribute |
| find          | search, extract, locate, recover        |
| start         | launch, create, begin, open             |
| make          | create, setup, build, generate, compose |
| ------------- | --------------------------------------- |

## III. Avoid generic names like "tmp" and "retval".

- Use the name that describes the variable values
- The name "tmp" should be used only in cases when being short-lived-block

## IV. Loop Iterators.

Assume we have arrays: clubs , members and cars

```ruby
for(int i = 0; i < clubs.size; i++) {
  for(int j = 0; j < members.size; j++) {
    for(int k = 0; k < members.size; k++) {
      <!-- the lots of code here -->
      ...
      ...
      ...
      i = j;
      j = k;
      k = i;
      wtf? the problem is: what are "i j k" mean ?
    }
  }
}
```

You should choose name of iterator (i, j, k) associate with the array (clubs, members, cars)

Example:

* i => club_i
* j => member_i
* k => car_k

## V. Attaching extra information into your names.

- Attaching values withs units:

Example:

| Normal Name | Refactor Colorful Name | Easy understading for using variable    |
| ----------- | ---------------------- | --------------------------------------- |
| delay       | delay_secs             | delay is seconds not minute or hour     |
| size        | size_mb                | size is megabyte for easy to calculator |
| max         | max_kbps               | max kilobizes for instance              |
| name        | plaintext_name         | name is define plaintext for save to DB |
| html        | html_utf8              | html is encoding with utf8              |
| data        | data_int               | data is a integer type to save DB       |
| ----------- | ---------------------- | --------------------------------------- |

## VI. Prefer MIN, MAX for Constant Limit.

Example:

- Normal name: CART_BIG_LIMIT = 10

- Refactor: MAX_ITEM_IN_CART = 10

### VII. Prefer First, Last, Begin, End for The Ranges.

Example:

- Use First Last:

| 1     | 2 | 3 | 4 | 5    | ... |
| ----- | - | - | - | ---- | --- |
| First | - | - | - | Last | --- |
| ----- | - | - | - | ---- | --- |

- Use Begin End:

| 1     | 2 | 3 | 4 | 5 | ... |
| ----- | - | - | - | - | --- |
| Begin | - | - | - | - | End |
| ----- | - | - | - | - | --- |

## VIII. Naming The Boolean Variable.

Avoid negated terms in a name.

Example:

```
# case 1:

bool disable_ssl = false;

# case 2:

bool use_ssl = true;

# => case 2 easy to read and understand than case 1
```

## IX. Aesthetics - The beautiful codes.

Make the beautiful codes:

- Column Alignment.
- Split the code into the paragraph with comment.
- Make consistent style: consistent is important than the 'right' style.

Example:

- refactor with column alignment:

```
# ex1:
bool use_ssl             = true;
integer max_item_in_cart = 20;
float black_box_price    = 29.99;
string vn_currency       = "VND";

# ex2:
commands[] = {
  { "timeout",      "NULL",            cmd_spec_time_out },
  { "timestamping", opt.timstamping,   cmd_boolean },
  { "tries",        opt.ntry,          cmd_number_inf },
  { "userproxy",    opt.use_proxy,     cmd_boolean },
  { "useragent",    opt.firefox_agent, cmd_spec_user_agent }
}
```

- refactor with split the code into the paragraph

```
# ex1:

def suggest_new_friends(user, email)
  # Get the user's friend email addresses.
  friends = user.friends()
  friend_emails = set(f.email for f in friends)

  # Import all email addresses from this user's email account.
  contacts = import_contacts(user.email, email)
  contact_emails = set(c.email for c in contacts)

  # Find matching users tha they aren't already friends with.
  non_friend_emails = contact_emails - friend_emails
  suggested_friends = User.objects.select(email___in=non_friend_emails)
end
```

- refactor with consisten style

```
# ex1:
function onClickSubmit() {
  ...
}
function onClickCancel()
{
  ...
}
function onClickSave() {
  ...
}

# refector to consistent {}

function onClickSubmit() {
  ...
}
function onClickCancel() {
  ...
}
function onClickSave() {
  ...
}

```

## X. When put comments in code ?.

- Don't comment for short code you can easy understand it. :enjoy:

- Don't comment to explain the BAD NAME => should fix the BAD NAME instead.

- Should comment for the logic , how the code flow run example for cases, if else, swith.

- Should comment to Recording your Thoughts, recording the IDEA of your code. :like:

- Should include the prefix to TAGGING or MARK the dangerous code example: "TODO", "FIXME", "HACK", or something like important thing in code "USER_UPDATE", "CART_CHECKUOT", "UPDATE_ORDER" ... :like:

_I have many chapter of The series of the art of readable code. They will be post as soon as possible in future. Keep in touch with me. Many thanks._