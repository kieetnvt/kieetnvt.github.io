---
layout: post
title: "How to Run Environment Variables in a Docker Container"
subtitle: ""
cover-img: /assets/img/docker-env.png
thumbnail-img: /assets/img/docker-env.png
share-img: /assets/img/docker-env.png
tags: [docker env]
author:
---

# How to Run Environment Variables in a Docker Container

### What are environmental variables?

Environment variables are user-definable values that are set outside individual software processes.

Environment variables don’t do anything on their own, but processes can read them to apply configuration changes and adjust their behavior — such as by setting credentials or enabling different features based on the environment variables set. This makes it possible to apply a new configuration each time an app is used or deployed without having to adjust the source code or implement your own config file mechanism.

You can set an environment variable in most shells by running the export key=value command:

~~~
export foo=bar
~~~

Now, processes launched within the shell can read the value of the foo environment variable and see it’s set to bar:

~~~
$ echo foo
bar
~~~

Environment variables can also be set for a single process by specifying them as a prefix to its command line:

~~~
foo=bar /usr/bin/my-app
~~~

### What are Docker environment variables?

Docker environment variables are predefined values that can be passed to a containerized application, allowing you to influence its behavior without altering the underlying image. These variables are essential for setting up application or script configurations, fine-tuning Docker images, and securely storing sensitive information such as database credentials or API keys.

#### Types of Docker environment variables

Here are some of the types of Docker environment variables:

- **Default environment variables**: These are predefined variables like HOSTNAME, HOME, and PATH, which give information about the container or the Docker host environment. The list of default variables can vary depending on the base image and Docker version.

- **ARG variables**: Defined in the Dockerfile, ARG variables are passed at build time and are not available in the final image or runtime. They can be used to set a default value or modify the build process, but once the image is built, they are no longer accessible inside the running container.

- **ENV variables**: These environment variables persist across the image build and are available at runtime, making them useful for runtime configuration. They can be defined in the Dockerfile or passed during docker run. Any environment variable declared with ENV remains in the final image and container.

- **Docker Compose environment variables**: Environment variables in Docker Compose can be defined either in the docker-compose.yml file under the environment section or through an external .env file. This is a common approach when working with multi-container applications.

- **Image-specific variables**: Some Docker images come with predefined environment variables specific to their functionality. The Docker image creators define and maintain these variables, often documenting them in the image’s official repository or documentation.

##### Example 1: Setting Docker environment variables with the `-e/–env` flag

The `-e/--env` flag is an option for the docker run command that lets you specify environment variables that will be set inside your container.

You can repeat the flag to set multiple environment variables for your container.

~~~
$ docker run -it \
  -e LOG_SERVER=192.168.0.1 \
  -e USE_UNENCRYPTED_STORAGE=1 \
  alpine:latest sh
~~~

The command above starts a new container running the alpine:latest image and sets the LOG_SERVER and USE_UNENCRYPTED_STORAGE environment variables. The -it flag enables interactive mode and attaches your terminal to the container, letting you run commands within it to check the variables have been set:

~~~
$ echo $LOG_SERVER
192.168.0.1

$ echo $USE_UNENCRYPTED_STORAGE
1
~~~

The variables have been added to the container’s environment. Processes running within the container can now read them.

Reusing variables already set in your shell

~~~
$ export LOG_SERVER=192.168.0.254

$ docker run -e LOG_SERVER alpine:latest
~~~

Docker will automatically set the variable inside the container, using the value inherited from your shell. In this example, the value of LOG_SERVER inside the container will be 192.168.0.254.

##### Example 2: Setting environment variables in Docker with a .env file

Another way to set Docker environment variables is with a `.env` file. This is a file that contains key-value pairs of environment variables:

~~~
LOG_SERVER=192.168.0.1
USE_UNENCRYPTED_STORAGE=1
~~~

To use a .env file with docker run, you must specify the file’s path by setting the --env-file flag:

~~~
$ docker run --env-file /path/to/env/file alpine:latest
~~~

Docker will read the environment variable key-value pairs from the file and set them inside the container.

You can repeat the flag to load variables from multiple .env files. It’s also possible to add the -e/--env file to set additional variables not included in your .env file.

##### Example 3: Passing environment variables using Docker Compose

Docker Compose enables declarative configuration for your Docker containers using a docker-compose.yml file. This lets you configure containers as code, version your changes, and conveniently manage stacks that run multiple services in separate containers.

You can set environment variables for a service using the environment field in your Compose file:

~~~
services:
  app:
    image: alpine:latest
    environment:
      - LOG_SERVER=192.168.0.1
~~~

Just like docker run, you can instruct Docker Compose to automatically pull in an existing variable’s value from your shell:

~~~
services:
  app:
    image: alpine:latest
    environment:
      - LOG_SERVER
~~~

Compose also supports interpolation, so you can combine different values into one:

~~~
services:
  app:
    image: alpine:latest
    environment:
      - LOG_SERVER=https://${LOG_SERVER}
~~~

Interpolation allows you to set a fallback value in case a variable isn’t set in your shell:

~~~
  app:
    image: alpine:latest
    environment:
      - LOG_SERVER=https://${LOG_SERVER:-127.0.0.1}
~~~

Here, the final value of LOG_SERVER inside the container will be taken from the LOG_SERVER variable set in your shell, or 127.0.0.1 if no assignment has been made. Regardless of the variable’s source, the value inside the container will always be prefixed with https://.

###### Using env files with Docker Compose

Compose supports .env files in a similar style to docker run. Use the env_file section of your service definition to specify the path to a file:

~~~
services:
  app:
    image: alpine:latest
    env_file: config.env
~~~

It’s also possible to specify multiple .env files and configure them as optional includes. Files marked as required: false won’t prevent docker compose up commands from completing, unlike the default setting, which requires referenced .env files to exist.

~~~
services:
  app:
    image: alpine:latest
    env_file:
      - path: config.env
        required: true
      - path: config.local.env
        required: false
~~~

Remember, you don’t always need to specify an env_file option when using Compose: The contents of the .env file in your working directory will be loaded automatically if the file exists. This provides a convenient way to override default values for the environment variables you define in your Compose file’s environment section.

“Thank you for reading! I hope you found this guide helpful and informative. If you have any questions or feedback, please feel free to leave a comment below.”