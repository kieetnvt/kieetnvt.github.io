---
layout: post
title: "Docker Image for Developers"
subtitle: A Beginner’s Guide
cover-img: /assets/img/docker-bg.png
thumbnail-img: /assets/img/docker.png
share-img: /assets/img/docker.png
tags: [docker images]
author: kieetnvt
---

Docker has become an essential tool for developers, simplifying the process of building, testing, and deploying applications.

One of the core concepts in Docker is the Docker image, a lightweight, standalone, and executable package that includes everything needed to run a piece of software. This guide will help beginners understand Docker images, how to create them, and why they are fundamental in modern development workflows.

Table of Contents
1. What is a Docker Image?
2. How Docker Images Work
3. Docker Images vs Containers
4. Pulling and Running Images from Docker Hub
5. Creating Your Own Docker Image
6. Managing Docker Images
7. Conclusion

### 1. What is a Docker Image?

A Docker image is essentially a blueprint for a container.
It contains all the necessary components such as the application code, libraries, environment variables, configuration files, and even the operating system needed to run the application.

Think of it as a snapshot or template that can be used to run containers.
Once you have an image, you can use it to run one or multiple instances of a container, ensuring that your application behaves the same across different environments (development, testing, production, etc.).

### 2. How Docker Images Work

Docker images are built layer by layer, where each layer represents a step in the process of building the image. Each layer is cached, so if a layer doesn't change, Docker can reuse it in future builds, significantly speeding up the process.

For example, if you update just the application code but not the base OS or dependencies, Docker will only rebuild the layers that have changed. This is key to Docker's efficiency.

Here’s a simple breakdown of how layers work:

1. Base Layer: This is typically a lightweight Linux distribution like Alpine or Ubuntu.

2. Application Layer: This includes the libraries and dependencies your application needs.

3. Custom Layers: Any specific configurations, environment variables, or additional tools your app requires.

### 3. Docker Images vs Containers

A common point of confusion for beginners is the distinction between Docker images and containers. To make the concept clearer, you can think of Docker images and containers as similar to object-oriented programming concepts:

- Docker Image: This is like a class in programming. A class defines the structure and behavior (methods and properties) but doesn't actually do anything until you create an instance of it. Similarly, a Docker image is a static blueprint that contains the instructions and dependencies for running an application, but it's not actively running by itself.

**Example**: A Car class might define attributes like color, model, and speed, but it's not an actual car until you create an instance.

- Docker Container: This is like an instance of a class. When you instantiate (run) a class, you get a live object that can interact with the world. Similarly, when you run a Docker image, it becomes a live Docker container that executes the application in an isolated environment.

**Example**: If you create an instance of the Car class, say a red sports car, you now have a live object that you can drive. Similarly, running a Docker image creates a running container that performs actions based on the instructions in the image.

This analogy helps visualize the difference: the Docker image is the design (class), and the Docker container is the working, running application (instance).

One more way to visualize this is to think of an image as the recipe, and the container as the actual dish created from that recipe.

### 4. Pulling and Running Images from Docker Hub

Docker Hub is a public registry where developers can share images. You can easily pull existing images from Docker Hub to run in your environment.

For example, to run an Nginx web server, you can pull and run the official Nginx image with just a few commands:

~~~
# Pull the Nginx image from Docker Hub
docker pull nginx

# Run the Nginx image as a container
docker run -d -p 8080:80 nginx
~~~

In this example:

- docker pull nginx: Downloads the latest Nginx image from Docker Hub.
- docker run -d -p 8080:80 nginx: Runs the container in detached mode (-d), exposing port 80 in the container to port 8080 on the host.

Now, if you visit http://localhost:8080, you should see the Nginx welcome page.

### 5. Creating Your Own Docker Image

While pulling images from Docker Hub is useful, developers often need to create custom images. This is where the Dockerfile comes in. A Dockerfile is a script containing a series of instructions on how to build a Docker image.

Here’s an example Dockerfile for a basic Go application:

~~~
# Start with a base image
FROM golang:1.18

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files
COPY go.mod ./
COPY go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o myapp

# Command to run the application
CMD ["./myapp"]
~~~

#### Building the Docker Image

Once you have your Dockerfile ready, you can build your Docker image using the following command:

~~~
docker build -t my-go-app .
~~~

This command tells Docker to build the image from the Dockerfile in the current directory (.) and tag it as my-go-app.

#### Running the Docker Image

To run the image you just built as a container:

~~~
docker run -d -p 8080:8080 my-go-app
~~~

This command starts a container from the my-go-app image and maps port 8080 of the container to port 8080 on the host.

### 6. Managing Docker Images

Docker provides several commands to help manage your images.

Listing images: To see a list of all Docker images on your system, run:

~~~
  docker images
~~~

Removing images: If you no longer need an image, you can remove it with:

~~~
  docker rmi <image-id>
~~~

Pruning unused images: Docker also provides a way to clean up unused images:

~~~
  docker image prune
~~~

This command will remove dangling images (images that are not tagged or associated with any container).

### 7. Conclusion

Docker images are a fundamental part of the Docker ecosystem, serving as the blueprint for containers. As a developer, understanding how to pull, create, and manage Docker images is crucial for building and shipping applications in a reliable and efficient manner.

Whether you're pulling official images from Docker Hub or creating custom ones using a Dockerfile, Docker images help ensure that your applications run consistently across different environments. With this guide, you should have a solid foundation to start working with Docker images in your development workflow.

Say thank [Suleiman Dibirov](https://dev.to/idsulik/a-beginners-guide-to-docker-image-for-developers-27ic)