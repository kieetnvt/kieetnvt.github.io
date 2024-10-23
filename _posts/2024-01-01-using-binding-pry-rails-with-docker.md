---
layout: post
title: Using binding.pry in rails with Docker
subtitle:
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/ruby.jpg
share-img: /assets/img/path.jpg
tags: [rails docker pry]
author: kieetnvt
---

First, add pry-rails to your Gemfile: [pry-rails](https://github.com/rweng/pry-rails)

```
gem 'pry-rails', group: :development
```

Then you'll want to rebuild your Docker container to install the gems

```
docker-compose build
```

You should now be able to add a break point anywhere in your code

```
binding.pry
```

The problem is that Docker just kind of ignores it and moves on. In order to actually halt execution and use pry as normal, you have to these options to docker-compose.yml:

```
app:
  tty: true
  stdin_open: true
```

And then attach to your process with docker attach project_app_1. pry-rails works here now.

The next time binding.pry is executed, the process should halt and display an IRB-like console on the rails server screen. But you still can't use it directly. You have to attach a terminal to the docker container.

In order to attach to a docker container, you need to know what its ID is. Use docker ps to get a list of the running containers and their ids.

```
docker ps
```

Then you can use the numeric ID to attach to the docker instance:

```
docker attach 75cde1ab8133
```

It may not immediately show a rails console, but start typing and it should appear. If you keep this attached, it should show the rails console prompt the next time you hit the pry breakpoint.

Neat things you should try with pry:

```
show-routes
show-models
show-source edit  # If you're in a controller, for instance

cd                # Navigate up or down class hierarchies. try `cd BasicObject`
ls                # Check out what's inside of a class - variables, etc.
```

And of course you can access local variables just by typing their names.

```
params
#=> <ActionController::Parameters {"controller"=>"lists", "action"=>"index"} permitted: false>
```

To end your pry-rails session, you can type exit as you would exit any irb instance.

```
exit
```

However, this does not detach the terminal from the docker container. This can be useful to continue debugging.

Additionally, I had two terminals open, one to review the server log and one to attach to my container to use pry-rails, but docker will timeout the server log while the attached terminal continues to run the rails server process. I'm okay with that - I can just leave the terminal attached. However, if you want to detach from the container without ending the process, you need to press ctrl-p + ctrl-q.

Source: [Kiet's Gist](https://gist.github.com/kieetnvt/214e00e1325470787669bf17ceeaae3f)
