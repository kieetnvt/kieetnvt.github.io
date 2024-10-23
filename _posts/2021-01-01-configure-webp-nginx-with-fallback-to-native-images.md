---
layout: post
title: Improve performance website
subtitle: Configure WebP NGINX with Fallback to native images
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/speed.png
share-img: /assets/img/path.jpg
tags: [webp nginx]
author: kieetnvt
---

## Configure WebP

Make sure the mime.types has type `webp`

```
/etc/nginx/mime.types
```

include

```
image/webp webp;
```

### Way 1

Create a location file and name it `/etc/nginx/locations/wp-content-uploads-webp.conf`:

```
location ~* /wp-content/uploads/.+\.(png|jpe?g)$ {

  try_files $uri.webp $uri =404;
}
```

Include `/etc/nginx/locations/wp-content-uploads-webp.conf` inside the root location from your blog, just before the try_files:

```
location / {
    include locations/wp-content-uploads-webp.conf;
    try_files $uri $uri/ /index.php?$args;
  }
```

### Way 2

```
http {
    # ...

    map $http_accept $webp_ext {
        default "";
        "~image\/webp" ".webp";
    }

    map $uri $file_ext {
        default "";
        "~(\.\w+)$" $1;
    }

    # ...
}
```

```
server {
    # ...

    location ~* "^(?<path>.+)\.(png|jpeg|jpg|gif)$" {
        try_files $path$webp_ext $path$file_ext =404;
    }

    # ...
}
```

### Way 3

```
# http config block
map $http_accept $webp_ext {
    default "";
    "~*webp" ".webp";
}

# server config block
location ~* ^(/wp-content/.+)\.(png|jpg)$ {
    add_header Vary Accept;
    try_files $1$webp_ext $uri =404;
}
```

### Way on My project :)

```
# in http block of file /etc/nginx/nginx.conf
# Webp
  map $http_accept $webp_ext {
    default "";
    "~image\/webp" ".webp";
  }

# in server block of file /etc/nginx/site-availables/xxx.conf

  location ~* ^(?<path>.+)\.(png|jpeg|jpg|gif)$ {
    set $img_path $1;
    add_header Vary Accept;
    try_files $img_path$webp_ext $uri =404;
  }

  location @unicorn_xxx {
  }
```

### Reload & Restart

```
sudo nginx -t && sudo service nginx reload
```

### Testing

Testing webp successfully configure:

```
curl -I -L -H "accept:image/webp,image/apng,image/*,*/*;q=0.8" <png's url here>
```

check the content-type of response header is `webp`

### Some explain for way 2

It works really nice, but what’s under the hood? For every request nginx creates two variables `$webp_ext` and `$file_ext`

`$webp_ext` equals `.webp` if current browser sends image/webp in the Accept header. Or it equals empty string otherwise.

`$file_ext` equals file extension (e.g. `.png`) of current URI if current URI has it. Or it equals empty string otherwise.

In the location for images, the `$path` without extension is captured from incoming URI.

And after that nginx tries to find a WebP version by concatenating `$path` and `$webp_ext` variables. If the file doesn’t exist nginx will try the next $path and $file_ext.

You will see a legacy file extension in the URI whether it’s WebP or not, but browsers are okay with that because nginx sends correct Content-Type for WebP files.

Source: [Kiet's Gist](https://gist.github.com/kieetnvt/27252dbed8c1e1cabda79dfca91acad5)