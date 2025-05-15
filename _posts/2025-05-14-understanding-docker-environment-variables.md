---
layout: post
title: "Understanding Docker Environment Variables and Precedence"
subtitle: "A comprehensive guide to managing environment variables in Docker"
cover-img: /assets/img/docker-env.png
thumbnail-img: /assets/img/docker-env.png
share-img: /assets/img/docker-env.png
tags: [docker, environment-variables, devops]
author: kieetnvt
---

Docker environment variables are a crucial aspect of container configuration and management. This guide will help you understand how environment variables work in Docker and their precedence order when defined in multiple places.

### Environment Variable Precedence in Docker

When working with Docker and Docker Compose, environment variables follow a specific precedence order. Here's the hierarchy from highest to lowest priority:

1. **Runtime Command Line Values**
   - Variables set with `docker compose run -e` or `docker compose up -e`
   - These take precedence over all other sources

2. **Docker Compose File**
   - Variables defined in the `environment` section of your `docker-compose.yml`
   - Second highest priority

3. **Shell Environment**
   - Variables from your current shell environment
   - Referenced in the Compose file

4. **Environment Files**
   - `.env` file in the same directory as `docker-compose.yml`
   - Files specified by `env_file` in the Compose file

5. **Dockerfile Variables**
   - Variables set using `ENV` statements
   - Lowest priority among user-defined sources

6. **Default Variables**
   - Built-in variables provided by the container runtime

### Example: Understanding Precedence in Practice

Let's look at a practical example showing how different sources of environment variables interact:

**Dockerfile Definition**

```dockerfile
FROM alpine:latest
ENV API_KEY=dockerfile_value
```

**Docker Compose Configuration**

```yaml
services:
  app:
    build: .
    environment:
      - API_KEY=compose_value
```

**.env File Content**

```
API_KEY=env_file_value
```

**Runtime Commands**

```bash
# Using shell environment
$ API_KEY=shell_value docker compose up

# Or using runtime override
$ docker compose run -e API_KEY=runtime_value app
```

Following the precedence rules:
- Runtime value (`runtime_value`) wins if provided
- Otherwise, Compose file value (`compose_value`) is used
- Next, shell environment value (`shell_value`) if present
- Then `.env` file value (`env_file_value`)
- Finally, Dockerfile value (`dockerfile_value`)

### Best Practices

**Use `.env` for Development Defaults**

```
# .env
DATABASE_URL=postgres://localhost:5432/dev
DEBUG=false
```

**Service-Specific Values in docker-compose.yml**

```yaml
services:
  web:
    environment:
      - DATABASE_URL=postgres://db:5432/prod
      - DEBUG=true
```

**Runtime Overrides for Testing**

```bash
docker compose run -e DEBUG=true web
```

**Security Considerations**

- Keep sensitive data in environment variables or `.env` files
- Never commit sensitive values to version control
- Use different `.env` files for different environments
- Consider using secrets management for production

### Documentation Tips

1. **Document Environment Variables**
   - List all required environment variables
   - Provide example values
   - Explain the purpose of each variable

2. **Version Control**
   - Include `.env.example` in version control
   - Add `.env` to `.gitignore`
   - Document the precedence order in README

### Conclusion

Understanding Docker environment variable precedence is crucial for proper container configuration. By following these best practices and understanding the precedence order, you can maintain flexible and secure Docker configurations while keeping sensitive data protected.

Remember to:
- Use the right source for each type of variable
- Document your environment variables clearly
- Follow security best practices
- Test variable precedence in your specific setup

For more detailed information, you can refer to the [official Docker documentation](https://docs.docker.com/compose/environment-variables/).