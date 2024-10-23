---
layout: post
title: NGINX Regex Matching
subtitle: NGINX Regex Matching
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/nginx.png
share-img: /assets/img/path.jpg
tags: [ruby]
author: kieetnvt
---

## If Statement and common condition

```
Syntax: if (condition) { ... }
Default:  —
Context:  server, location
```

A condition may be any of the following:

- a variable name: false if the value of a variable is an empty string or “0”;

- comparison of a variable with a string using the “=” and “!=” operators;

```
set $NAME ""; => setting var is "", and assign to $NAME
if ($NAME = "0") {} => auto-false
if ($NAME = "") {} => auto-fasle
if ($NAME != "TEST") {}
```

- matching of a variable against a regular expression using the `~` (for case-sensitive matching)

- `~*` (for case-insensitive matching) operators

- Negative operators `“!~”` and `“!~*”` are also available

-  If a regular expression includes the “}” or “;” characters,
the whole expressions should be enclosed in single or double quotes

- checking of a file existence with the “-f” and “!-f” operators;

- checking of a directory existence with the “-d” and “!-d” operators;

- checking of a file, directory, or symbolic link existence with the “-e” and “!-e” operators;

- checking for an executable file with the “-x” and “!-x” operators.

```
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$ /msie/$1 break;
}

if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
    set $id $1;
}

if ($request_method = POST) {
    return 405;
}

if ($slow) {
    limit_rate 10k;
}

if ($invalid_referer) {
    return 403;
}
```

## Multiple condition

Syntax: set $variable value;
Default:  —
Context:  server, location, if

NGINX only has single condition, we need using variable stragety to make multiple condition:

```
  set $UD "";

  if ($request_method = 'GET'){
    set $UD "${UD}GET";
  }

  if ($request_filename !~* .(gif|svg|html|jpe?g|png|json|ico|js|css|flv|swf|pdf|xml|woff|woff2)$ ) {
    # detect static files request

    set $UD "${UD}RED";
  }

  if ($UD = "GETRED") {
    # add trailing slash for every url except static files, redirect to slash url
    # http://test.com => http://test.com/

    rewrite ^([^.\?]*[^/])$ $1/ permanent;
  }
```

## $1..$9 Meaning?

Let check example:

```
rewrite ^(/data/.*)/geek/(\w+)\.?.*$ $1/linux/$2.html last;

=> url/data/distro/geek/test.php will get rewritten as url/data/distro/linux/test.html
```

- $1 and $2 will capture the appropriate strings from the original URL that doesn’t change

- $1 in the replacement string will match whatever is inside the 1st parenthesis `1st ( )` in the reg-ex.

- In our example, $1 is /data/

- Similarly $2 will match whatever is inside the 2nd parenthesis ( ) in the reg-ex.

- So, $2 is (\w+), which is any word that comes after the /geek/ in the original URL.

- In our example, $2 is test

Note: `*$` – This indicates the extension in the original URL.  even though you call .php in the original URL, it will only serve the .html file in the rewritten URL.

## The last thing, How to output variable in nginx log for debugging ?

### Way 1

You can send nginx variable values via headers. Handy for development.

Example:

```
add_header X-uri "$uri";

and you'll see in your browser's response headers:

X-uri:/index.php

location ~ \.php$ {
    add_header X-debug-message "A php file was used" always;
    ...
}

```

### Way 2

You can set a custom access log format using the log_format directive which logs the variables you're interested in.

https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format

### Way 3

Using Echo https://github.com/openresty/echo-nginx-module

REF: https://serverfault.com/questions/404626/how-to-output-variable-in-nginx-log-for-debugging



