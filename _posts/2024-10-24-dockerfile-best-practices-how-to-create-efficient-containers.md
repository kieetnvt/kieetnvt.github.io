---
layout: post
title: "Dockerfile Best Practices"
subtitle: How to Create Efficient Containers
cover-img: /assets/img/docker-bg.png
thumbnail-img: /assets/img/docker.png
share-img: /assets/img/docker.png
tags: [docker container practice]
author:
---

In the era of microservices and cloud computing, Docker has become an indispensable tool for application development and deployment.

Containerization allows developers to package applications and their dependencies into a single, portable unit, ensuring predictability, scalability, and rapid deployment. However, the efficiency of your containers largely depends on how optimally your Dockerfile is written.

In this article, we'll explore best practices for creating Dockerfiles that help you build lightweight, fast, and secure containers.

## Dockerfile Basics

### What Is a Dockerfile?

A Dockerfile is a text document containing a set of instructions to assemble a Docker image. Each instruction performs a specific action, such as installing packages, copying files, or defining startup commands. Proper use of Dockerfile instructions is crucial for building efficient containers.

### Key Dockerfile Instructions

- **FROM**: Sets the base image for your new image.

- **RUN**: Executes a command in a new layer on top of the current image and commits the result.

- **CMD**: Specifies the default command to run when a container is started.

- **COPY**: Copies files and directories from the build context into the container filesystem.

- **ADD**: Similar to COPY but with additional features like extracting archives.

- **ENV**: Sets environment variables.

- **EXPOSE**: Informs Docker which ports the container listens on at runtime.

- **ENTRYPOINT**: Configures a container to run as an executable.

- **VOLUME**: Creates a mount point for external storage volumes.

- **WORKDIR**: Sets the working directory for subsequent instructions.

### Best Practices for Writing Dockerfiles

#### Use Minimal Base Images

The base image serves as the foundation for your Docker image. Choosing a lightweight base image can significantly reduce the final image size and minimize the attack surface.

- **Alpine Linux**: A popular minimal image around 5 MB in size.

~~~
FROM alpine:latest
~~~

> Pros: Small size, security, fast downloads.

> Cons: May require additional configuration; some packages might be missing or behave differently due to using musl instead of glibc.

- **Scratch**: An empty image ideal for languages that can compile static binaries (Go, Rust).

~~~
FROM scratch
COPY myapp /myapp
CMD ["/myapp"]
~~~

#### Reduce Layers

Each `RUN`, `COPY`, and `ADD` instruction adds a new layer to your image. Combining commands helps reduce the number of layers and the overall image size.

For example:

- Inefficient:

~~~
RUN apt-get update
RUN apt-get install -y python
RUN apt-get install -y pip
~~~

- More Efficient:

~~~
RUN apt-get update && apt-get install -y \
    python \
    pip \
 && rm -rf /var/lib/apt/lists/*
~~~

#### Optimize Layer Caching

Docker uses layer caching to speed up builds. The order of instructions affects caching efficiency.

- **Copy Dependency Files First**: Copy files that change less frequently (like package.json or requirements.txt) before copying the rest of the source code.

- **Minimize Changes in Early Layers**: Changes in early layers invalidate the cache for all subsequent layers.

#### Install Dependencies Wisely

Remove temporary files and caches after installing packages to reduce image size.

~~~
RUN pip install --no-cache-dir -r requirements.txt
~~~

#### Manage Secrets Carefully

Never include sensitive data (passwords, API keys) in your Dockerfile.

- **Use Environment Variables**: Pass secrets at runtime using environment variables.

- **Leverage Docker Secrets**: Use Docker Swarm or Kubernetes mechanisms for managing secrets.

#### Optimize Image Size

- **Delete Unnecessary Files**: Clean up caches, logs, and temporary files within the same RUN command as the installation. This ensures that these temporary files do not persist in any intermediate layers, effectively reducing the final image size.

~~~
RUN apt-get update && apt-get install -y --no-install-recommends package \
      && apt-get clean && rm -rf /var/lib/apt/lists/*
~~~

- **Minimize Installed Packages**: Install only the packages you need by using flags like `--no-install-recommends`. This avoids pulling in unnecessary dependencies, further slimming down the image.

~~~
RUN apt-get install -y --no-install-recommends package
~~~

Note: To maximize image size reduction, combine this installation with cleanup commands in the same RUN statement as shown above.

- **Use Optimization Tools**: Utilize tools like Docker Slim which can automatically analyze and optimize your Docker images by removing unnecessary components and reducing their size without altering functionality.

#### Utilize .dockerignore

A `.dockerignore` file lets you exclude files and directories from the build context, reducing the amount of data sent to the Docker daemon and protecting sensitive information.

** Example .dockerignore**:

~~~
.git
node_modules
Dockerfile
.dockerignore
~~~

#### Employ Multi-Stage Builds

Multi-stage builds allow you to use intermediate images and copy only the necessary artifacts into the final image.

**Example for a Go Application**:

~~~
# Build Stage
FROM golang:1.16-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Final Image
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]
~~~

#### Run as Non-Root User

For enhanced security, avoid running applications as the root user.

~~~
RUN adduser -D appuser
USER appuser
~~~

#### Scan for Vulnerabilities

- **Use Scanning Tools**: Tools like Trivy, Anchore, or Clair can help identify known vulnerabilities.

- **Regularly Update Images**: Keep your base images and dependencies up to date.

#### Logging and Monitoring

- **Direct Logs to STDOUT/STDERR**: This allows for easier log collection and analysis.

- **Integrate with Monitoring Systems**: Use tools like Prometheus or the ELK Stack to monitor container health.

## Examples and Recommendations

### Optimized Dockerfile Example for a Node.js Application

~~~
# Use the official Node.js image based on Alpine Linux
FROM node:14-alpine

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Create a non-root user and switch to it
RUN addgroup appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose the application port
EXPOSE 3000

# Define the command to run the app
CMD ["node", "app.js"]
~~~

### Additional Recommendations

- **Pin Versions**: Use specific versions of base images and packages to ensure build reproducibility.

~~~
FROM node:14.17.0-alpine
~~~

- **Stay Updated**: Regularly update dependencies and base images to include security patches.

- **Use Metadata**: Add LABEL instructions to provide image metadata.

~~~
LABEL maintainer="yourname@example.com"
~~~

- **Set Proper Permissions**: Ensure files and directories have appropriate permissions.

- **Avoid Using Root**: Always switch to a non-root user for running applications.

### Conclusion

Creating efficient Docker images is both an art and a science. By following best practices when writing your Dockerfile, you can significantly improve the performance, security, and manageability of your containers. Continuously update your knowledge and stay informed about new tools and methodologies in the containerization ecosystem. Remember, optimization is an ongoing process, and there's always room for improvement.

Say thank [Suleiman Dibirov](https://dev.to/idsulik/dockerfile-best-practices-how-to-create-efficient-containers-4p8o)