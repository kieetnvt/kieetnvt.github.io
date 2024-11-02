---
layout: post
title: "Deploy Node.js Applications on AWS EC2 with Docker and GitHub Actions"
subtitle: ""
cover-img: /assets/img/docker-real-ship.jpeg
thumbnail-img: /assets/img/docker.png
share-img: /assets/img/docker-real-ship.jpeg
tags: [nodejs docker ec2 github actions]
author:
---

This guide demonstrates how to seamlessly deploy your Node.js application onto an Amazon Web Services (AWS) EC2 instance using the power of Docker and GitHub Actions, ensuring streamlined and reliable deployment workflows.

### Prerequisites

- Node.js application: Ensure you have a Node.js application ready for deployment.

- GitHub repository: Create or use an existing repository to host your application code.

- Docker installed: Install Docker locally(if running self-hosted runner) to build and manage container images. If you’re running workflow with GitHub hosted runners then Docker is already installed there.

- AWS account: Sign up for a free AWS account if you haven’t already.

- EC2 instance: Create an EC2 instance in AWS with appropriate specifications for your application. Configure security groups to allow inbound traffic on the port your application uses (e.g., port 3000).

- SSH Client: Install an SSH client like PuTTY or Terminal (on macOS/Linux) to connect to your EC2 instance.

### AWS EC2 Setup:

Use below commands to setup Docker:

~~~
sudo apt-get update
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo docker run hello-world
docker ps
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker
docker --version
~~~

Use below reference to setup self-hosted runner on EC2:

[Adding self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners)

Now, follow below steps to create required Docker file and Workflow file to deploy you Node.js code on AWS EC2:

### Dockerfile Creation:

Within your application directory, create a file named Dockerfile with the following content, replacing <IMAGE_NAME> with your desired image name and <PORT> with your application's port:

~~~
FROM node:16.20.1
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm","run","start"]
~~~

### GitHub Actions Workflow Creation:

Within your GitHub repository, create a directory named .github (if it doesn't exist) and a file named `workflows/deploy.yml` within it.
It will contain below code:

~~~
name: CICD

on:
  push:
    branches: [cicd-docker-ec2]

jobs:
  build:
    runs-on: [ubuntu-latest]
    steps:
      - name: Checkout source
        uses: actions/checkout@v3
      - name: Login to docker hub
        run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
      - name: Build docker image
        run: docker build -t username/nodejs-app .
      - name: Publish image to docker hub
        run: docker push username/nodejs-app:latest

  deploy:
    needs: build
    runs-on: [aws-ec2]
    steps:
      - name: Pull image from docker hub
        run: docker pull username/nodejs-app:latest
      - name: Delete old container
        run: docker rm -f nodejs-app-container
      - name: Run docker container
        run: docker run -d -p 5000:5000 --name nodejs-app-container username/nodejs-app
~~~

### Flow Chart:

![Github action flow](/assets/img/github-actions-flow.webp)

After setting up the Docker and Workflow file, whenever developer will commit any changes in the repository, workflow will be triggered for that specified branch and code will be deployed to AWS EC2.

Let’s understand the workflow example:

##### General Workflow Definition:

- `name: CICD`: This line defines the name of the workflow, which is displayed in the GitHub Actions interface.

##### Workflow Trigger:

- `on`: This section specifies when the workflow should be triggered.

- `push`: This triggers the workflow upon a push event to the repository.

- `branches: [cicd-docker-ec2]`: This further refines the trigger to only run the workflow when a push event occurs on the cicd-docker-ec2 branch.

##### Jobs:

- `jobs`: This section defines the different jobs that will be executed within the workflow.

- `build`: This is the first job named "build."

- `runs-on: [ubuntu-latest]`: This specifies that the job should run on a virtual machine with the ubuntu-latest runner image. You can use your own machine as self-hosted runner, it should have Docker installed.

- `steps`: This section defines the individual steps that will be executed within the "build" job.

- `name: Checkout source`: This step uses the actions/checkout@v3 action to check out the source code of the repository from GitHub to the runner's machine.

- `name: Login to docker hub`: This step logs in to Docker Hub using the username and password stored in the GitHub secrets named DOCKER_USERNAME and DOCKER_PASSWORD respectively.

![Github action settings](/assets/img/github-action-settings.webp)

##### Dependencies and Execution:

- `deploy`: This is the second job named "deploy."

- `needs: build`: This indicates that the "deploy" job depends on the successful completion of the "build" job before it can start.

- `runs-on: [aws-ec2]`: This specifies that the job should run on an AWS EC2 instance. You'll need to configure your workflow to have access to and run jobs on your EC2 instance.

- `steps`: This section defines the steps within the "deploy" job.

- `name: Pull image from docker hub`: This step pulls the latest version of the built Docker image (integrationninjas/nodejs-app:latest) from Docker Hub onto the EC2 instance.

- `name: Delete old container`: This step (optional) removes any existing container named nodejs-app-container before running the new image.

- `name: Run docker container`: This step runs the pulled Docker image as a detached container named nodejs-app-container.

- `-p 5000:5000`: This maps the container's port 5000 to the host machine's port 5000. This allows access to the running application on the EC2 instance through port 5000.

- `--name nodejs-app-container`: This assigns the name nodejs-app-container to the running container, making it easier to identify and manage.

Overall, this workflow automates the process of building and deploying a Node.js application to an AWS EC2 instance using Docker. It ensures that the application is built and pushed to Docker Hub in the “build” job, and then pulled and run as a container on the EC2 instance in the “deploy” job.