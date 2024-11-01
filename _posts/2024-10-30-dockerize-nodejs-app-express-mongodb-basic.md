---
layout: post
title: "Basic: Dockerized Express and MongoDB App with Docker Compose"
subtitle: ""
cover-img: /assets/img/docker-bg.png
thumbnail-img: /assets/img/docker-expressjs.jpg
share-img: /assets/img/docker-expressjs.jpg
tags: [expressjs docker]
author:
---

In this guide, we’ll walk you through the process of setting up a development environment for your application, containerizing it with Docker, using Docker Compose

a Dockerized Node.js, Express, and MongoDB application using Docker Compose!

### Folder Structure

Here’s the recommended folder structure for organizing your Dockerized Node.js, Express, and MongoDB application:

![docker express folder](/assets/img/docker-express-js-folder.webp)

### Step 1: Dockerfile for Express API Server

Let’s start by creating a Dockerfile for our Express API server. This file will define the environment and dependencies needed to run our application within a Docker container.

~~~
# Dockerfile for Express API server
FROM node
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
CMD ["node", "index.js"]
~~~

### Step 2: Build the Docker Image

~~~
docker build -t "api-server" .
~~~

### Step 3: Create a Docker Compose Configuration

Now, create a docker-compose.yaml file to define the services and their configurations.

~~~
version: '3' # docker-compose version
services: # services which our app going to use. (list of containers we want to create)
  mongo: # container name
    image: mongo # On which image container will build
    ports:
      - "27017:27017"

  api-server:
    image: api-server
    ports:
      - "9000:3000"
    depends_on:
      - mongo
~~~

### Step 4: Change connection String for MongoDB

~~~
mongodb://mongo:27017/UsersDB
~~~

### Step 5: Running the Application

With our Docker Compose configuration ready, we can now spin up our application using a single command:

~~~
docker-compose up
~~~

Once the containers are up and running, you can access your Express API server in your browser:

`http://localhost:9000/`

### Enhancing Docker Compose File

We can enhance our Docker Compose configuration to ensure the persistence of our MongoDB data within containers. Let’s update our docker-compose.yaml file accordingly.

~~~
version: '3' # docker-compose version
services: # services which our app going to use. (list of containers we want to create)
  mongoCont: # container name
    image: mongo # which image container will build on
    ports:
      - "27017:27017"
    networks: # adding network
      - mern-app
    volumes:
      - mongo-data:/data/db

  api-server:
    build: . # build the Docker image for the service using the Dockerfile located in the current directory
    ports:
      - "9000:3000"
    networks: # adding network
      - mern-app
    depends_on:
      - mongoCont

# allow services to talk to each other while providing isolation from other docker container
# running on the same host
networks:
  mern-app:
    driver: bridge

volumes: # enable persistence of database data across container restart
  mongo-data:
    driver: local
~~~

In this updated Docker Compose configuration:

- We’ve added a networks section to define a custom network named mern-app to allow communication between containers.

- The api-server and mongoCont services have been configured to use this network.

- MongoDB container has been renamed to mongoCont for clarity.

- We’ve also ensured the persistence of MongoDB data by using a named volume mongo-data.

- With these enhancements, we no longer need to run the build command separately, Docker Compose will automatically build the Docker image for the api-server service using the Dockerfile located in the current directory.

Now as we change the Mongo Container name our connection string will be:

~~~
mongodb://mongoCont:27017/UsersDB
~~~

Now, Run The Application

~~~
docker-compose up
~~~

“Thank you for reading! I hope you found this guide helpful and informative. If you have any questions or feedback, please feel free to leave a comment below.”

