---
layout: post
title: Run AWS on Your Laptop for Free
subtitle: Practice AWS, Azure, and GCP commands locally without cloud bills
cover-img: /assets/img/docker.png
thumbnail-img: /assets/img/docker.png
share-img: /assets/img/docker.png
tags: [aws, gcp, azure, devops, cloud, docker]
author: kieetnvt
---

Cloud practice can get expensive quickly.

Free credits are useful when you are starting out, but they disappear fast if you are experimenting with EKS clusters, S3 buckets, queues, secrets, Lambda-style workflows, or other real cloud services. The result is familiar: you watch the theory, understand the concept, then avoid hands-on practice because you do not want a surprise bill.

There is another way to practice: run cloud service emulators locally.

## The Problem With Free Tiers

A few years ago, signing up for AWS, Azure, or GCP often felt safe because the free tier gave you plenty of room to experiment. Today, credits can run out quickly for anyone doing serious practice.

Spinning up infrastructure, testing managed services, and repeating tutorials all cost money once you leave the free tier. That financial risk is one reason many people stop practicing cloud platforms after the theory stage.

## The Solution: Local Emulation

Emulation means your cloud CLI commands talk to a local service that behaves like the real cloud API.

Instead of sending a request to AWS, Azure, or GCP, your command hits an emulator running on your laptop. The emulator returns responses that look like the cloud provider's API responses, so you can practice the same commands and workflows without touching real cloud infrastructure.

Developers already use this idea all the time. We mock databases, queues, and external services during local development because we do not need production infrastructure for every test. The same approach works for cloud learning.

## Enter Floci

[Floci](https://floci.io/#install) is an open-source tool for running cloud service emulation locally. It supports major cloud providers including AWS, Azure, and GCP, with the largest current coverage on AWS.

Useful links:

- [Floci GitHub repository](https://github.com/floci-io/floci)
- [Supported Floci services](https://floci.io/floci/services/)

For local practice, the important part is simple: you can run common cloud workflows on your machine without creating a cloud account, attaching a credit card, or consuming real cloud resources.

## Prerequisites

You only need Docker running on your machine.

You do not need:

- An AWS account
- An Azure subscription
- A GCP project
- A credit card

## Step 1: Run Floci With Docker

Start Floci in a Docker container:

~~~bash
docker run -d --name floci \
  -p 4566:4566 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  floci/floci:latest
~~~

This exposes the local cloud emulator on port `4566`.

## Step 2: Point AWS CLI to Floci

Set environment variables so the AWS CLI and AWS SDKs talk to your local Floci instance instead of real AWS:

~~~bash
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
~~~

The credentials can be dummy values because the requests stay local.

## Step 3: Try a Local S3 Workflow

Create a bucket:

~~~bash
aws s3 mb s3://my-bucket
~~~

Create a test file:

~~~bash
echo "Why pay for S3 when Floci is free?" > hello-floci.txt
~~~

Upload it:

~~~bash
aws s3 cp hello-floci.txt s3://my-bucket/hello-floci.txt
~~~

Download it back:

~~~bash
aws s3 cp s3://my-bucket/hello-floci.txt hello-back.txt
cat hello-back.txt
~~~

You just practiced an S3 workflow through the AWS CLI, but everything stayed on your laptop.

## Why This Matters

Local cloud emulation helps you practice with less friction:

- You use real CLI commands and SDK patterns
- You can repeat tutorials without burning cloud credits
- You can experiment without worrying about cleanup bills
- You can test workflows before touching real infrastructure
- You can learn services like S3, EKS, KMS, SQS, Secrets Manager, and EventBridge locally when supported by the emulator

It is not a full replacement for real cloud infrastructure. Some provider-specific behavior, IAM edge cases, managed-service limits, networking details, and production deployment concerns still require the real platform.

But for learning, local development, and repeatable practice, it removes a major barrier.

## Final Thoughts

If billing anxiety is stopping you from practicing cloud engineering, local emulation is worth trying.

Install Docker, start Floci, point your CLI to `localhost:4566`, and practice the same kinds of workflows you would run on AWS, Azure, or GCP. When you are ready to deploy for real, you will already be more comfortable with the commands and service concepts.
