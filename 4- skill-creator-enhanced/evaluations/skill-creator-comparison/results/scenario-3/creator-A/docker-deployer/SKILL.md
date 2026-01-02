---
name: docker-deployer
description: Guide for deploying applications with Docker. This skill should be used when users want to containerize and deploy their applications.
---

# Docker Deployer

Deploy applications using Docker containers.

## When to Use

Use when a user asks to:
- Containerize an application
- Create a Dockerfile
- Deploy with Docker

## How to Deploy

### Step 1: Create Dockerfile

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Step 2: Build Image

```bash
docker build -t myapp .
```

### Step 3: Run Container

```bash
docker run -p 3000:3000 myapp
```

### Step 4: Push to Registry

```bash
docker tag myapp registry/myapp:latest
docker push registry/myapp:latest
```

### Step 5: Deploy to Cloud

For AWS ECS, create task definition and service.

## Output

- `Dockerfile` - Container definition
- `docker-compose.yml` - Multi-container setup (if needed)
