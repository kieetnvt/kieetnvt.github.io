---
layout: post
title: "The art of readable code: Overview"
subtitle: "The art of readable code: Overview"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/readablecode.jpg
share-img: /assets/img/path.jpg
tags: [readable code]
author: kieetnvt
---

> Overview

> Key idea: Code should be easy to understand.

Now I show you 10 ideas for readable code, code not only for yourself understand but also for your teammate understand.

# *Pack information into your names*

* Be specific:
    - `GetPage` --> `DownloadPage`
* Avoid generics names:
    - not use `tmp` `retval`
* Attach details:
    - `duration` --> `duration_ms`
    - `password` --> `plaintext_password`
* Be care full with abbreviation (từ viết tắt):
    - `BEManager`, `str`, `eval`
* Avoid ambiguous naming (từ mơ hồ)
    - `CART_TOO_BIG_LIMIT` --> `CART_MAX_ITEMS`
    - `STOP` --> `LAST`
    - `read_password` --> `needs_to_read_password` or `password_has_been_read`

# *Aesthetic matter*

* Be consistent (phù hợp)
* Write code like text
* Aesthetic with comment and some code following
* Example:

```ruby
def hello_word_process
    # say hello!
    generate_name
    say_hello

    # retrieve user information
    retrieve_information
    show_information

    # deal processing
    login_with_current_bank
    processing_with_bank

    return redirect_to root_path
end
```

# *Comment wisely (comment khôn ngoan)*

* Comment with purpose of function or explain the code
* Example:

```ruby
# remove everything after the second '*'
name = '*'.join(line.split('*')[:2])
```

* Fix bad name, do not explain the name

* Comment code flaws: `FIXME`, `TODO`, `HACK`, `XXX`

# *Make your control flow easy to follow*

* Write expression like you say it
* Deal with positive first:

```ruby
if (positive)
# case one
else
# case true
```

* Deal with simpler first:

```ruby
if (!file)
# log an error with file
else
# Do stuff
...
...
...
...
```

* Avoid `do..while` loops

* Return early first

```ruby
def capital_of_world(province = 'hanoi')
return false if province == 'saigon'
...
...
end
```

* Minimize the Nesting:

DONOT USE:

```ruby
if ...
    if ...
        if ...
        else
        end
    end
else
end
```

* Use De Morgan's Law

DONOT USE:

```ruby
if (!(file_exists && !is_protected))
    Error("Sorry, could not read the file")
```

SHOULD USE:

```ruby
if (!file_exists && is_protected)
    Error("Sorry, could not read the file")
```

# *Many variables broad scope changing frequently*

* Remove unnecessary vars:

DONOT USE:

```ruby
now = DateTime.zone.now
root_message.last_view_time = now
```

SHOULD USE:

```ruby
root_message.last_view_time = DateTime.zone.now
```

* Make your vars visible by as few line of code as possibles

* Prefer write-once variables

# *Do ONE THING at a TIME*

* Extract un-related subproblems
* Figure out what tasks your code is doing
* Separate those tasks into functions or sections
* Devide to conquer

# *DONOT write the whels*

* Question your requirement
* DONOT over engineer
* Be familiar with your libraries
* Break the rules when you have a good reason to do it.
