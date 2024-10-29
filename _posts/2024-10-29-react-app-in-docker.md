---
layout: post
title: "React App In Docker"
subtitle:
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/react-app-docker.png
share-img: /assets/img/react-app-docker.png
tags: [react app docker]
author:
---

Using React to create a basic static site. Using Docker to containerize the application, making it easy to run anywhere.
Within the Docker image, Using a simple NGINX web server to serve up the static site’s production build files.

### Creating the Project

To create a project using create-react-app:

~~~
npx create-react-app my-app
~~~

### Creating the Dockerfile

~~~
FROM node:14.9.0 AS build-step

WORKDIR /build
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:1.18-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build-step /build/build /frontend/build
~~~

This Dockerfile has two parts to it, the first part is referred to as build-step which you can see on the first line. This step specifies our working directory as /build.

Next, the package files are copied to the working directory, followed by an npm install.

We then copy the remaining files from our project into the working directory, and finally, run an npm run build command to build the production-ready code.

The second step is to configure the nginx server. You’ll notice that we copy a nginx.conf file (we’ll look at this in the next step). And then, finally, we copy the build folder from the first step into a directory for nginx to use.

### Creating the Nginx Config

In the application root directory, we’ll create a config file for nginx:

~~~
touch nginx.conf
~~~

~~~
user  nginx;
worker_processes  1;
events {
  worker_connections  1024;
}
http {
  include /etc/nginx/mime.types;
  server {
    listen 80;
    root /frontend/build;
    index index.html;
    location / {
      try_files $uri /index.html;
    }
  }
}
~~~

This configures a simple nginx web server, and specifies the root directory and index file that we copied in the later step of our Dockerfile. The nginx server will listen on port 80 as default.

### .dockerignore

It is wise to add a .dockerignore file to the repository to minimize the number of files copied to the docker image.

~~~
touch .dockerignore
~~~

Copy the contents of the default .gitignore file into the .dockerignore file.

### Creating a docker-compose file

Now, we’ll create a docker-compose file to help us with building our Docker image and passing any config that we need.

~~~
touch docker-compose.yml
~~~

~~~
version: '3.2'
services:
  my-app:
    build:
      context: .
      dockerfile: 'Dockerfile'
    ports:
      - '3000:80'
    volumes:
      - ./:/frontend
~~~

This specifies the service name, and the source of the Dockerfile ` (in this case, ‘Dockerfile’). It also maps the port of the nginx server (80) to an external port 3000.

We can now build the image using the following command:

~~~
docker-compose up -d --build my-app
~~~

This might take some time. Once complete, you should be able to access your React app on localhost:3000, served from within the Docker image.

### Summary

In just a few steps we’ve been able to Dockerise a simple React app. This can help to simplify the process of deploying your production-code, or sharing the application with a friend to run locally.