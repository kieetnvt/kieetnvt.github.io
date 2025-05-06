---
layout: post
title: "Docker Networking for Developers"
subtitle: A Beginner’s Guide
cover-img: /assets/img/docker-bg.png
thumbnail-img: /assets/img/docker.png
share-img: /assets/img/docker.png
tags: [docker networking]
author: kieetnvt
---

Docker has revolutionized how we build, ship, and run applications by containerizing them.

However, one key aspect of using Docker effectively is understanding how containers communicate with each other and the outside world. This article provides a beginner-friendly guide to Docker networking, which is essential for any developer who wants to leverage Docker efficiently.

Table of Contents
1. What is Docker Networking?
2. Docker Network Types
- Bridge Network
- Host Network
- None Network
- Overlay Network
3. Hands-on with Docker Networking
- Creating and Managing Networks
- Connecting Containers to Networks
- Exposing Services to the Host
4.  Conclusion

### 1. What is Docker Networking?

Docker networking allows containers to communicate with each other and external resources.
Each container is isolated by default, meaning it won’t automatically communicate with others unless connected to a shared network.
Docker provides a flexible and robust networking model that simplifies connecting containers.

In short, Docker networking handles:

- Communication between containers
- Communication between containers and the outside world
- Defining isolation boundaries for containerized applications

### 2. Docker Network Types

Docker provides several network drivers, each suited for different use cases.
Understanding these network types is crucial to choosing the right one for your applications.

#### Bridge Network (Default)

The bridge network is the default network driver used by Docker when you create containers.
Containers on the same bridge network can communicate with each other using IP addresses or container names.

**Use case**: This is commonly used for applications with multiple containers on a single host that need to communicate internally, such as microservices in development environments.

~~~
# List containers on the default bridge network
docker network inspect bridge
~~~

#### Host Network

In the host network, the container shares the host’s networking namespace.
This means that the container can use the host’s IP address and ports directly.

**Use case**: This is useful for performance-critical applications where you need to avoid network overhead, but you lose isolation between the container and the host.

~~~
docker run --network host <image>
~~~

#### None Network

As the name implies, the none network driver disables all networking for the container.
This is useful when the container does not need any external or internal networking.

**Use case**: Use this for containers that don’t need any network communication, such as for specific background tasks.

~~~
docker run --network none <image>
~~~

#### Overlay Network

The overlay network is used for multi-host Docker setups, where containers running on different hosts need to communicate with each other.
It requires a Docker Swarm or Kubernetes setup.

**Use case**: This is essential for distributed systems that span across multiple Docker hosts.

~~~
docker network create --driver overlay my-overlay-network
~~~

### 3. Hands-on with Docker Networking

Now, let's explore how to work with Docker networks in real-world scenarios.

#### Creating and Managing Networks

By default, Docker creates a bridge network when you run containers. However, you can create custom networks for more advanced setups.

~~~
# Create a custom bridge network
docker network create my-custom-network
~~~

You can inspect your networks using:

~~~
docker network ls  # Lists all networks
docker network inspect my-custom-network  # Detailed information about a specific network
~~~

#### Connecting Containers to Networks

Once you've created a custom network, you can attach containers to it.

~~~
# Run a container and attach it to a custom network
docker run -d --name container1 --network my-custom-network nginx

# Run another container and attach it to the same network
docker run -d --name container2 --network my-custom-network redis
~~~

Containers on the same network can communicate with each other by container names.

~~~
# Inside container1, you can reach container2 by its name
ping container2
~~~

#### Exposing Services to the Host

**If you want a service running inside a container to be accessible from your host or the outside world, you need to expose its ports.**

~~~
docker run -d -p 8080:80 --name webserver nginx
~~~

In this case, the Nginx web server running inside the container will be accessible from your host machine at `localhost:8080`.

### 4. Conclusion

Docker networking is a powerful feature that allows containers to interact seamlessly with each other and the external world.
By understanding different Docker network types and how to configure them, developers can efficiently build and deploy containerized applications.
Whether you’re developing a small app or a complex multi-container system, Docker networking makes it all possible.

If you’re new to Docker, this guide should give you a solid foundation to start experimenting with container networking.
As you become more comfortable, you can dive into more advanced topics like overlay networks for distributed applications or fine-tuning network performance.

Say thank [Suleiman Dibirov](https://dev.to/idsulik/a-beginners-guide-to-docker-networking-for-developers-2ab8)