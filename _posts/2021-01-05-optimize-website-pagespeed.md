---
layout: post
title: Optimize webpage speed
subtitle: Strategy
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/speed.png
share-img: /assets/img/path.jpg
tags: [optimize webpage speed strategy]
author: kieetnvt
---

## Optimize webpage speed:

- Tools: Google Pagespeed Insight, Gtmetrix.com, Webpagetest.org, Image Analysis of Webpagetest.org

- Tools mobile: Webpagetest.org, [thinkwithgoogle](https://testmysite.thinkwithgoogle.com/)

----------

## Strategy:

1. Using sprite CSS for all images

2. Optimize images using tool Tinypng.com

3. Eliminate render-blocking JavaScript in above-the-fold content

4. Use `content_for` custom JS in Rails

5. Optimize CSS Delivery

6. Example of inlining a small css file

7. Don't inline large data URIs

8. [Don’t inline CSS attributes](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery)

9. Add expires headers

10. onfigure the Expires header for Rails under nginx

  ```
  if ($request_uri ~* "\.(ico|css|js|gif|jpe?g|png)\?[0-9]+$") {
    expires max;
    break;
  }

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }
  ```

----------

## How to set up nginx cookie free headers

When your website sets a cookie, the web browser sends this cookie when requesting static files like js, css and png. This increases network activity.

Being cookie free means using a different domain or subdomain for serving files like images, stylesheets and Javascript.

So you need to create a new virtual host file on Nginx with the same document root:

```
server {
  listen 80;
  server_name static.example.com;
  root /var/www/example.com;

  fastcgi_hide_header Set-Cookie;
}
```

Create an A Record for static.example.com in the DNS section.

Edit your website to make the css, js and image files use this subdomain in its URL.

----------

## Load Externals JS at the end of body:

- JS at <head> => need add defer attribute => this way will load JS and donot break the DOM loading.

- JS at the end of <body> => don't need add any attribute, DOM will load html then load JS, then excuted JS.

----------

### Use Webpack (Wepacker gem for Rails) to optimize both CSS, JS, ASSETS IMAGES.

- Later will update the Strategy use webpacker

----------

### Use google devtools to find CSS & JS un-use for Homepage (Need optimize the content loaded per page
must do keep content load minimum per page, this is a goal)

- the great tool: [lighthouse](https://developers.google.com/web/tools/lighthouse/)

- [chrome-devtools](https://developers.google.com/web/tools/chrome-devtools/ui#command-menu)

----------

### Optimize with WebP, Font caching, Pre-loading third party JS, Browser caching

- Besides maybe changing the current fonts we also need to think about loading and caching of the font. Because some users see their default settings like Calibri, Arial etc.

- [webfont-optimization](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/webfont-optimization)

- Browser Caching (nginx) : https://developers.google.com/web/tools/lighthouse/audits/cache-policy

```
location ^~ /assets|packs-staging/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }
```

- Pre-loading thir party JS: https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/loading-third-party-javascript/

- Optimize using `WebP` technique:

Some resources to start:

- [configuration-to-deliver-webp](https://www.keycdn.com/support/optimus/configuration-to-deliver-webp)

- [webp-nginx-with-fallback](https://alexey.detr.us/en/posts/2018/2018-08-20-webp-nginx-with-fallback/)

Should to try to create a solution without creating every image in .webp format Otherwise we will get a lot more maintenance.
However, we still need a fallback if the browser does not support webp.

----------

Ref:

- [yahoo](https://developer.yahoo.com/performance/rules.html)

- [configure-the-expires-header-on-your-rails-site-with-nginx](http://effectif.com/articles/configure-the-expires-header-on-your-rails-site-with-nginx)

- [far-future-expires-headers-for-ruby-on-rails-with-nginx](http://www.agileweboperations.com/far-future-expires-headers-for-ruby-on-rails-with-nginx)

- [how-to-set-up-nginx-cookie-free-headers](https://www.digitalocean.com/community/questions/how-to-set-up-nginx-cookie-free-headers)

- [add-expires-headers](https://gtmetrix.com/add-expires-headers.html)

----------