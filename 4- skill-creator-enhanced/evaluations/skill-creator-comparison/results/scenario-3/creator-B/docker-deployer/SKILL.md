---
name: docker-deployer
description: |
  Automates Docker containerization and deployment for applications.
  This skill should be used when users want to containerize applications,
  set up CI/CD pipelines, or deploy to container platforms.
---

# Docker Deployer

Automate containerization and deployment with production-grade Docker practices.

## What This Skill Does

- Creates optimized Dockerfiles for different languages/frameworks
- Generates docker-compose for local development
- Sets up CI/CD pipeline configuration
- Deploys to container platforms (ECS, GKE, etc.)

## What This Skill Does NOT Do

- Manage Kubernetes clusters (use k8s-specific tools)
- Handle secrets management (use Vault, AWS Secrets Manager)
- Monitor running containers (use observability tools)

---

## Before Implementation

| Source | Gather |
|--------|--------|
| **Codebase** | Language, framework, dependencies, ports |
| **Conversation** | Target platform, CI/CD system, environment needs |
| **Skill References** | Optimization patterns from `references/` |

---

## Required Clarifications

| Clarification | Why |
|---------------|-----|
| Language/Framework | Determines base image and build steps |
| Target platform | ECS vs GKE vs self-hosted affects config |
| CI/CD system | GitHub Actions vs GitLab CI vs Jenkins |
| Environment count | Dev/staging/prod affects compose setup |

---

## Deployment Workflow

```
1. Analyze → 2. Dockerfile → 3. Compose → 4. CI/CD → 5. Deploy Config
```

### 1. Analyze Application

Determine:
- Runtime requirements
- Build dependencies vs runtime dependencies
- Exposed ports
- Environment variables needed

### 2. Generate Dockerfile

Use multi-stage builds. Run `scripts/generate_dockerfile.py`.

See `references/dockerfile-patterns.md` for optimization.

### 3. Generate docker-compose

For local development with dependencies (database, cache).

### 4. CI/CD Pipeline

Generate based on platform:
- GitHub Actions: `.github/workflows/deploy.yml`
- GitLab CI: `.gitlab-ci.yml`

### 5. Platform Config

Generate deployment configuration for target platform.

---

## Pre-Delivery Checklist

- [ ] Multi-stage build used (smaller image)
- [ ] Non-root user configured
- [ ] .dockerignore created
- [ ] Health check defined
- [ ] No secrets in image
- [ ] CI/CD tests before deploy

---

## Reference Files

| File | Use When |
|------|----------|
| `references/dockerfile-patterns.md` | Optimizing Dockerfiles |
| `references/security.md` | Container security practices |
| `references/ci-cd-templates.md` | Pipeline configurations |
