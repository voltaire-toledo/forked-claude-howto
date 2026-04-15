# GitHub Actions & Automation Integration

GitHub Actions is the event-driven automation layer that surrounds your Copilot workflow. Use Copilot to *generate* your workflows, and let Actions *run* them every time code changes. This module covers how Copilot and Actions work together, mapping to the Claude Hooks concept.

---

## Table of Contents

- [Copilot and GitHub Actions Synergy](#copilot-and-github-actions-synergy)
- [Using Copilot to Write Workflows](#using-copilot-to-write-workflows)
- [Copilot for Pull Requests](#copilot-for-pull-requests)
- [copilot-setup-steps.yml for the Coding Agent](#copilot-setup-stepsyml-for-the-coding-agent)
- [Pre-commit Hooks with Copilot](#pre-commit-hooks-with-copilot)
- [CI/CD Pipeline Generation](#cicd-pipeline-generation)
- [Actions Integration Diagram](#actions-integration-diagram)
- [Example Workflow Files](#example-workflow-files)
- [Mapping from Claude Hooks](#mapping-from-claude-hooks)

---

## Copilot and GitHub Actions Synergy

| Task | Claude Hooks | Copilot + GitHub Actions |
|------|-------------|--------------------------|
| Validate before edit | `pre-tool` hook | Pre-commit hook |
| Validate after edit | `post-tool` hook | `on: push` Actions workflow |
| Send notification | Notification hook | Actions → Slack / webhook step |
| Auto-format code | `post-tool` hook | `on: push` + format + auto-commit |
| Run tests | `post-tool` hook | `on: pull_request` CI workflow |

The key difference: Claude Hooks run *synchronously during a session*, while GitHub Actions run *asynchronously in the cloud on Git events*.

---

## Using Copilot to Write Workflows

Copilot understands GitHub Actions YAML syntax deeply. Use `@workspace` for repo-aware generation:

```
@workspace create a GitHub Actions CI workflow for this Node.js project that:
1. Triggers on push to main and on pull requests
2. Runs on ubuntu-latest
3. Sets up Node.js 20 with npm cache
4. Runs: npm ci, npm run lint, npm test
5. Uploads test coverage to Codecov
6. Posts a status check that blocks PR merge if tests fail
```

```
@workspace generate a deployment workflow that:
- Triggers when a release is published
- Builds a Docker image and tags it with the release version
- Pushes to GitHub Container Registry
- Deploys to a Kubernetes cluster using kubectl
- Sends a Slack notification on success or failure
```

### Iterating on Generated Workflows

```
# After Copilot generates a workflow, ask follow-up questions:
"Add a matrix strategy to test on Node.js 18, 20, and 22"

"Add a cache step for the node_modules directory"

"Make the deploy job run only when the build and test jobs succeed"

"Add a timeout of 10 minutes to each job"
```

---

## Copilot for Pull Requests

### Auto-Generated PR Descriptions

When you open a PR on GitHub.com, Copilot can generate a summary:

1. Click the **Copilot icon** (✨) in the PR description field
2. Copilot analyses the diff and writes a structured description
3. Edit as needed before posting

The generated description typically includes:
- What changed and why
- Affected files
- Testing instructions
- Screenshots (if UI changes are detected)

### Copilot Code Review

Enable Copilot code review in repository settings. It posts inline comments on PRs automatically:

```yaml
# .github/workflows/copilot-review.yml
name: Copilot Code Review
on:
  pull_request:
    types: [opened, synchronize]

permissions:
  pull-requests: write
  contents: read

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Copilot Code Review
        uses: github/copilot-code-review@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

---

## copilot-setup-steps.yml for the Coding Agent

The coding agent runs in a cloud sandbox. Customise its environment with `.github/copilot-setup-steps.yml`:

```yaml
# .github/copilot-setup-steps.yml
steps:
  - name: Set up Node.js 20
    uses: actions/setup-node@v4
    with:
      node-version: '20'
      cache: 'npm'

  - name: Install dependencies
    run: npm ci

  - name: Start test services
    run: |
      docker compose -f docker-compose.test.yml up -d
      # Wait for services to be ready
      npx wait-on tcp:5432 tcp:6379 --timeout 30000

  - name: Run database migrations
    run: npm run db:migrate
    env:
      DATABASE_URL: ${{ secrets.TEST_DATABASE_URL }}
```

The coding agent uses these steps to build a working environment before attempting any code changes.

---

## Pre-commit Hooks with Copilot

Use Copilot to generate pre-commit configurations and hook scripts:

### Generate a pre-commit config

```
@workspace generate a .pre-commit-config.yaml for this Python project that:
- Runs black (formatter)
- Runs ruff (linter)
- Runs mypy (type checker)
- Runs pytest on changed files only
- Checks for secrets with detect-secrets
```

### Example Generated Config

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.12.0
    hooks:
      - id: black
        language_version: python3.11

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.9
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        additional_dependencies: [types-requests]

  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

### Ask Copilot to Write Custom Hooks

```
Write a bash pre-commit hook that:
1. Runs ESLint on staged .ts and .tsx files only
2. Fails if there are any errors (not warnings)
3. Shows the file names of failing files
4. Exits 0 if there are no staged TypeScript files
```

---

## CI/CD Pipeline Generation

### Complete Node.js CI Pipeline

```
@workspace create a production-ready CI pipeline for this Node.js Express API:
- Test: lint, unit tests, integration tests (with postgres)
- Build: Docker image with multi-stage build
- Security: OWASP dependency check, Snyk scan
- Deploy: to staging on PR merge, production on release tag
- Notify: post status to Slack #deployments channel
```

### Generated Example

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '20'
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: testpass
          POSTGRES_DB: testdb
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Unit tests
        run: npm test -- --coverage

      - name: Integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:testpass@localhost:5432/testdb

      - name: Upload coverage
        uses: codecov/codecov-action@v4

  build:
    name: Build Docker Image
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v4

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
```

---

## Actions Integration Diagram

```mermaid
flowchart LR
    Dev([👤 Developer]) --> Copilot["🤖 Copilot Chat\n@workspace generate workflow"]
    Copilot --> WorkflowYML["📄 .github/workflows/ci.yml"]

    Dev --> Commit["git push"]
    Commit --> |"on: push"| Actions["⚙️ GitHub Actions"]

    Actions --> Test["🧪 Run Tests"]
    Actions --> Lint["🔍 Lint Code"]
    Actions --> Build["🐳 Build Image"]
    Actions --> Security["🔒 Security Scan"]

    Test -- "pass" --> Deploy["🚀 Deploy"]
    Test -- "fail" --> Notify["🔔 Notify Developer"]

    Deploy --> |"PR opened"| PRReview["📝 Copilot PR Review\nauto-generated description\n+ inline review comments"]
    PRReview --> |"Approved + merged"| Prod["🌐 Production"]

    style Copilot fill:#1a73e8,color:#fff
    style Actions fill:#2da44e,color:#fff
    style PRReview fill:#6e40c9,color:#fff
```

---

## Mapping from Claude Hooks

| Claude Hook | Trigger | GitHub Equivalent |
|-------------|---------|-------------------|
| `pre-tool` | Before each tool call | Pre-commit hook |
| `post-tool` | After each tool call | `on: push` Actions job |
| `notification` | Session events | GitHub Actions + notification step |
| `stop` | Session ends | PR merge trigger |
| Custom validation | Session-level | Branch protection + required status checks |
| Automated formatting | Session-level | Formatting job + auto-commit |

> **Key insight:** Claude Hooks give you fine-grained control during a session; GitHub Actions give you coarse-grained control at the repository level. Think of Actions as "hooks for your entire team's workflow, running in the cloud."

---

## Next Module

[07 — Copilot Workspace & VS Code Integration →](../07-workspace/README.md)
