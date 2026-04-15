# Copilot Agent Mode & Coding Agent

Copilot's agentic capabilities let it autonomously plan, execute, and verify multi-step tasks — no more pasting code back and forth. This module covers two distinct agentic modes: **local agent mode** in VS Code, and the **cloud-based coding agent** triggered via GitHub issues.

---

## Table of Contents

- [Agent Mode vs Chat Mode](#agent-mode-vs-chat-mode)
- [Enabling Agent Mode in VS Code](#enabling-agent-mode-in-vs-code)
- [The Agentic Loop](#the-agentic-loop)
- [Available Tools in Agent Mode](#available-tools-in-agent-mode)
- [Agent Execution Diagram](#agent-execution-diagram)
- [GitHub Copilot Coding Agent](#github-copilot-coding-agent)
- [copilot-setup-steps.yml](#copilot-setup-stepsyml)
- [Best Practices for Agent Prompts](#best-practices-for-agent-prompts)
- [Example Workflows](#example-workflows)
- [Mapping from Claude Subagents](#mapping-from-claude-subagents)

---

## Agent Mode vs Chat Mode

| Dimension | Chat Mode | Agent Mode |
|-----------|-----------|------------|
| **Scope** | Single response | Multi-step autonomous task |
| **File edits** | Suggests (you apply) | Applies directly (with approval) |
| **Tool calls** | None | File read/write, terminal, search |
| **Iteration** | One turn | Self-corrects until task complete |
| **Best for** | Answering questions, single edits | Refactors, feature implementation |

---

## Enabling Agent Mode in VS Code

1. Open Copilot Chat (`Ctrl+Shift+I`)
2. Click the **mode selector** at the bottom of the chat input (shows "Chat" by default)
3. Select **Agent**
4. Type your task description

Or use the keyboard shortcut: open chat and immediately type your prompt — agent mode can be activated via the toggle that appears.

```
# Agent mode prompt examples
Add comprehensive error handling to all async functions in src/api/

Refactor the UserService class to use the repository pattern

Create a complete Jest test suite for the auth module with mocked dependencies
```

---

## The Agentic Loop

When you submit a task in agent mode, Copilot follows this loop:

1. **Plan** — Analyse the task, determine what steps are needed
2. **Tool call** — Read relevant files, search the codebase, run commands
3. **Implement** — Make the planned changes
4. **Verify** — Run tests, check for compilation errors, lint
5. **Iterate** — If verification fails, diagnose and fix
6. **Report** — Summarise what was done and ask for approval on destructive ops

The loop continues until the task is complete or Copilot needs clarification.

---

## Available Tools in Agent Mode

| Tool | Description | Example Use |
|------|-------------|-------------|
| **Read file** | Read any file in the workspace | Understanding existing code |
| **Write file** | Create or modify files | Implementing changes |
| **Run terminal command** | Execute shell commands | Running tests, installing deps |
| **Search codebase** | Search for patterns or symbols | Finding all usages of a function |
| **Web search** | Look up documentation | Finding API references |
| **Create file** | Create new files | Scaffolding new modules |
| **Delete file** | Remove files (requires approval) | Cleanup tasks |

---

## Agent Execution Diagram

```mermaid
flowchart TD
    Prompt([💬 User Task Prompt]) --> Plan

    Plan["📋 Plan Steps\n1. Read existing code\n2. Identify changes\n3. Implement\n4. Test"]

    Plan --> Read["📖 Read Files\n(file read tool)"]
    Read --> Analyse["🧠 Analyse Context"]
    Analyse --> Implement["✏️ Write Changes\n(file write tool)"]
    Implement --> Verify{"🔍 Verify\n(run tests / lint)"}

    Verify -- "Tests pass" --> Approve{"👤 Human Approval\nNeeded?"}
    Verify -- "Tests fail" --> Diagnose["🔧 Diagnose Failure"]
    Diagnose --> Fix["🛠️ Fix Issues"]
    Fix --> Verify

    Approve -- "Destructive op" --> UserReview["👤 User Reviews\n& Approves"]
    Approve -- "Non-destructive" --> Done
    UserReview -- "Approved" --> Done
    UserReview -- "Rejected" --> Revert["↩️ Revert Changes"]

    Done([✅ Task Complete])
    Revert --> Plan
```

---

## GitHub Copilot Coding Agent

The **coding agent** is a cloud-based version of agent mode, triggered by assigning a GitHub issue to `@copilot`. It runs in an isolated cloud environment and opens a pull request with the changes.

### How to Use It

```bash
# Option 1: Assign from the issue UI
# 1. Open a GitHub issue
# 2. In the Assignees panel, type @copilot and select it
# 3. Copilot starts working (you'll see a status banner)
# 4. A draft PR is created when the agent is done

# Option 2: From the command line
gh issue edit 42 --add-assignee copilot

# Option 3: Mention in a comment
# Post a comment on the issue: "@copilot please implement this"
```

### What the Coding Agent Can Do

- Read the full repository
- Write code, tests, and documentation
- Run tests and CI checks
- Commit and push to a new branch
- Open a draft pull request
- Respond to review feedback (post a comment on the PR)

### Limitations

- Cannot access external services unless you configure them in `copilot-setup-steps.yml`
- Cannot merge PRs — human review is always required
- Best for well-scoped, clearly described issues

### Writing Issues for the Coding Agent

```markdown
## Title
Add input validation to the user registration endpoint

## Description
The `POST /api/users` endpoint currently accepts any JSON without validation.
Add Zod schema validation to:
1. Require: email (valid format), password (min 8 chars), name (max 100 chars)
2. Return 400 with field-level error messages on invalid input
3. Add unit tests covering valid input, each invalid field, and multiple errors

## Acceptance Criteria
- [ ] Zod schema defined in `src/schemas/user.schema.ts`
- [ ] Schema applied in `src/routes/users.ts`
- [ ] Unit tests in `src/routes/users.test.ts`
- [ ] All existing tests still pass
```

---

## copilot-setup-steps.yml

The `.github/copilot-setup-steps.yml` file customises the cloud environment the coding agent runs in — you can pre-install tools, set environment variables, and run setup scripts.

```yaml
# .github/copilot-setup-steps.yml
steps:
  # Install Node.js dependencies
  - name: Install dependencies
    run: npm ci

  # Install additional tools the agent might need
  - name: Install global tools
    run: |
      npm install -g tsx
      npm install -g @types/node

  # Set up a test database
  - name: Start test database
    run: |
      docker run -d \
        --name test-db \
        -e POSTGRES_PASSWORD=testpass \
        -e POSTGRES_DB=testdb \
        -p 5432:5432 \
        postgres:16

  # Run database migrations
  - name: Run migrations
    run: npm run db:migrate
    env:
      DATABASE_URL: postgresql://postgres:testpass@localhost:5432/testdb

  # Cache dependencies for speed
  - name: Cache node modules
    uses: actions/cache@v4
    with:
      path: node_modules
      key: ${{ runner.os }}-node-${{ hashFiles('package-lock.json') }}
```

---

## Best Practices for Agent Prompts

### Scope the Task Clearly

```
# ❌ Too broad
"Improve the codebase"

# ✅ Well-scoped
"Add TypeScript strict mode to the project and fix all resulting type errors in src/api/"
```

### Specify Constraints

```
"Refactor the payment module to use the strategy pattern.
Constraints:
- Do not change the public API (function signatures)
- All existing unit tests must continue to pass
- Add new tests for the strategy implementations"
```

### Provide Context Files

```
"Using the patterns from src/users/users.service.ts as a reference,
create src/products/products.service.ts with the same structure"
```

### Break Large Tasks Into Steps

```
"Step 1 of 3: Add the Product model to src/models/product.ts with fields:
id (UUID), name (string), price (decimal), stock (integer), createdAt (datetime)"
```

---

## Example Workflows

### Add Tests to an Untested Module

```
Agent task:
"The src/billing/ directory has no tests. Create a comprehensive test suite:
1. Unit tests for BillingService methods (mock the Stripe client)
2. Integration tests for billing routes (use supertest)
3. Coverage target: 80%
Use the existing test patterns from src/users/users.test.ts as reference."
```

### Migrate API to New Version

```
Agent task:
"Migrate all API calls from axios v0 to axios v1 syntax.
The breaking changes are in src/api/client.ts.
After migration, run npm test to verify nothing is broken."
```

### Generate Documentation

```
Agent task:
"Generate a docs/API.md file documenting every endpoint in src/routes/.
For each endpoint, include: HTTP method, path, request body schema, response schema, example request, example response."
```

---

## Mapping from Claude Subagents

| Claude Subagents | Copilot Equivalent |
|------------------|-------------------|
| Spawn child `claude` process | Agent mode in VS Code |
| Remote subagent execution | Copilot coding agent (cloud) |
| Custom subagent script | `copilot-setup-steps.yml` |
| Parallel subagents | Multiple agent sessions (sequential in Copilot) |
| Merge subagent results | Copilot agent applies all changes to same branch |
| Subagent with custom context | `@workspace` + custom instructions |

> **Key difference:** Claude Subagents can run in parallel; Copilot agent mode is sequential. For parallelism, use multiple Copilot coding agent issues or combine agent mode with a task runner.

---

## Next Module

[05 — Model Context Protocol (MCP) →](../05-mcp/README.md)
