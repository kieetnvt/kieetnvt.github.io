---
layout: post
title: "NestJS App In Docker"
subtitle: ""
cover-img: /assets/img/docker-bg.png
thumbnail-img: /assets/img/nestjs-docker.png
share-img: /assets/img/nestjs-docker.png
tags: [nestjs docker]
author:
---

NestJS is a backend framework which aims to simplify server-side development by providing a consistent and abstract interface on top of the usual tools such as express.
With NestJS this is no different, building a Docker image of your application’s production build can help. Keep reading to find out how.

### Creating the Project

We’ll be using NestJS to create a basic web server. We’ll also be using Docker to containerise the application, making it easy to run anywhere.

First, install the NestJS CLI globally:

~~~
npm i -g @nestjs/cli
~~~

Then, create a project:

~~~
nest new nest-project
~~~

Once it’s complete, we should be able to run the application using `npm run start`, and see ‘Hello World!’ in our browser at `localhost:3000`

If we want to run it in `watch mode`, so that the server restarts when we make any code changes, we can simply run `npm run start:dev` instead.

This is simply the local dev version of the application. It is mostly used to give quick feedback whilst developing the application.

### Creating the Dockerfile

~~~
FROM node:18-alpine AS builder
WORKDIR "/app"
COPY . .
RUN npm ci
RUN npm run build
RUN npm prune --production
FROM node:18-alpine AS production
WORKDIR "/app"
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json ./package-lock.json
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD [ "sh", "-c", "npm run start:prod"]
~~~

This Dockerfile has two parts to it, the first part is referred to as builder which you can see on the first line. This step specifies our working directory as /app.

Next, the package files are copied to the working directory, followed by an `npm run ci`.

Next we run an `npm run build` command to build the production-ready code. This will place the built application code in the /dist folder within the working directory.

Having carried out the build, we can safely remove any non-production dependencies from the node_modules folder. We do this using the command `npm prune --production`, which specifies that we only want to keep production dependencies.

> It’s worth noting that in a standard NestJS app the npm run build script makes use of some dev dependencies. This is why we have to install all dependencies first, then run the build script, before removing non-production dependencies using the prune script.

The second and final step of the Dockerfile is the one which will be used to create the image for our application. In here we simply copy the folders and files from the first step that we need: package.json, package-lock.json, /dist, and /node_modules.

Finally, we run our command to start the production code in the container.

### Creating a docker-compose file

~~~
version: '3.2'
services:
  nest-project:
    build:
      context: .
      dockerfile: 'Dockerfile'
    ports:
      - '3000:3000'
~~~

This specifies the service name, and the source of the Dockerfile (in this case, ‘Dockerfile’). It also maps the port of the application (3000) to an external port 3000. If we wanted to expose a different port then we could update this. e.g. - '4000:3000' would expose port 4000 for us to access the application on.

We can now build the image using the following command:

~~~
docker-compose up -d --build nest-project
~~~

This might take some time. Once complete, you should be able to access your NestJS app on localhost:3000, served from within the Docker container.

### Summary

In just a few steps we’ve been able to Dockerise a simple NestJS app. This can help to simplify the process of deploying your production-code, or sharing the application with a friend to run locally.

