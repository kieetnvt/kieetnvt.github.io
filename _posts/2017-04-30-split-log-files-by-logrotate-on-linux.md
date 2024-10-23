---
layout: post
title: "Split small logs file by logrotate on Linux system"
subtitle: "Split small logs file by logrotate on Linux system"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/linux.jpeg
share-img: /assets/img/path.jpg
tags: [nginx webserver]
author: kieetnvt
---

# Split small logs file by logrotate on Linux system

## Best practice:

- My best practice configure logrotate.conf for Staging ENV: It will keep logs around 7 days:

```
/home/deploy/apps/app_name/shared/log/*.log {
  daily
  rotate 7
  missingok
  compress
  delaycompress
  notifempty
  copytruncate
}
```

- Note: the logrotate will run automatic on cronjob of linux

## This is fantastically easy. Each bit of the configuration does the following:

- daily – Rotate the log files each day. You can also use weekly or monthly here instead.

- missingok – If the log file doesn’t exist, ignore it

- rotate 7 – Only keep 7 days of logs around

- compress – GZip the log file on rotation

- delaycompress – Rotate the file one day, then compress it the next day so we can be sure that it won’t
interfere with the Rails server

- notifempty – Don’t rotate the file if the logs are empty

- copytruncate – Copy the log file and then empties it. This makes sure that the log file Rails is writing to always exists so you won’t get problems because the file does not actually change. If you don’t use this, you would need to restart your Rails application each time.

- Running Logrotate To run logrotate manually, we just do: sudo /usr/sbin/logrotate -vdf /etc/logrotate.conf

## My best practice configure logrotate.conf for Production ENV

My best practice configure logrotate.conf for Production ENV: It will keep logs around 1 year

```
/home/deploy/apps/app_name/shared/log/*.log {
  weekly
  rotate 52
  missingok
  compress
  delaycompress
  notifempty
  copytruncate
}
```
