# Transition Guide: Claude Code → GitHub Copilot

This guide helps Claude Code users understand how every concept from the original **Claude How To** repository maps to an equivalent feature in **GitHub Copilot**. Whether you are migrating a workflow or just learning Copilot with prior Claude experience, use this as your reference.

---

## Table of Contents

- [Conceptual Overview](#conceptual-overview)
- [Full Module Mapping Table](#full-module-mapping-table)
- [Concept-by-Concept Translation](#concept-by-concept-translation)
  - [CLAUDE.md → copilot-instructions.md](#claudemd--copilot-instructionsmd)
  - [Slash Commands → Chat Commands](#slash-commands--chat-commands)
  - [Skills → Copilot Extensions](#skills--copilot-extensions)
  - [Subagents → Agent Mode & Coding Agent](#subagents--agent-mode--coding-agent)
  - [MCP → Copilot MCP Support](#mcp--copilot-mcp-support)
  - [Hooks → GitHub Actions](#hooks--github-actions)
  - [Plugins → VS Code Extensions](#plugins--vs-code-extensions)
  - [Checkpoints → Git + PR Features](#checkpoints--git--pr-features)
  - [Advanced Features → Multi-Model & Workspace](#advanced-features--multi-model--workspace)
  - [Claude CLI → gh copilot CLI](#claude-cli--gh-copilot-cli)
- [Conversion Notes by Module](#conversion-notes-by-module)
- [New Course Modules](#new-course-modules)

---

## Conceptual Overview

Claude Code and GitHub Copilot share the same fundamental goal — to make developers faster and more effective using AI — but they take different architectural approaches:

| Dimension | Claude Code | GitHub Copilot |
|-----------|-------------|----------------|
| **Primary interface** | Terminal / editor | Editor (VS Code, JetBrains, etc.) + GitHub.com |
| **Configuration file** | `CLAUDE.md` | `.github/copilot-instructions.md` |
| **Invocation model** | CLI-first with agent loop | IDE-first with optional agent mode |
| **Extension model** | Skills (markdown templates) | Extensions (GitHub Apps + webhooks) |
| **Automation** | Hooks (shell scripts on events) | GitHub Actions workflows |
| **Cloud agent** | Claude Subagents | GitHub Copilot coding agent (via issues) |
| **Protocol support** | MCP servers | MCP servers (VS Code settings / mcp.json) |
| **Multi-model** | Anthropic model family | GPT-4.1, Claude 3.x, Gemini, o3-mini |
| **CLI tool** | `claude` | `gh copilot` |

Both systems are converging on the Model Context Protocol (MCP) as a shared standard, so skills learned on either platform transfer increasingly well.

---

## Full Module Mapping Table

| # | Claude How To Module | GitHub Copilot Equivalent | New Course Module |
|---|----------------------|---------------------------|-------------------|
| 01 | [Slash Commands](01-slash-commands/) | Chat Commands (`/explain`, `/fix`, `/tests`, `/doc`, `/new`) | [01-chat-commands](copilot-course/01-chat-commands/) |
| 02 | [Memory (CLAUDE.md)](02-memory/) | Custom Instructions (`.github/copilot-instructions.md`) | [02-custom-instructions](copilot-course/02-custom-instructions/) |
| 03 | [Skills](03-skills/) | GitHub Copilot Extensions | [03-extensions](copilot-course/03-extensions/) |
| 04 | [Subagents](04-subagents/) | Agent Mode + Copilot Coding Agent | [04-agent-mode](copilot-course/04-agent-mode/) |
| 05 | [MCP](05-mcp/) | MCP in VS Code / `.vscode/mcp.json` | [05-mcp](copilot-course/05-mcp/) |
| 06 | [Hooks](06-hooks/) | GitHub Actions + pre-commit | [06-actions-integration](copilot-course/06-actions-integration/) |
| 07 | [Plugins](07-plugins/) | VS Code Extensions + `copilot-setup-steps.yml` | [07-workspace](copilot-course/07-workspace/) |
| 08 | [Checkpoints](08-checkpoints/) | Git commits + Copilot PR features | [08-version-control](copilot-course/08-version-control/) |
| 09 | [Advanced Features](09-advanced-features/) | Multi-model, Copilot Workspace, Vision | [09-advanced-features](copilot-course/09-advanced-features/) |
| 10 | [CLI](10-cli/) | `gh copilot suggest` / `gh copilot explain` | [10-cli](copilot-course/10-cli/) |

---

## Concept-by-Concept Translation

### CLAUDE.md → copilot-instructions.md

**Claude Code** uses a `CLAUDE.md` file at the repo root (or `~/.claude/CLAUDE.md` for user-level) to give persistent instructions to every session. It accepts arbitrary markdown and is read automatically.

**GitHub Copilot** uses `.github/copilot-instructions.md` at the repo root. It works in VS Code (Copilot Chat with `@workspace`) and Copilot coding agent sessions. Organization-level instructions can be set via GitHub organization settings.

| Claude | Copilot | Notes |
|--------|---------|-------|
| `CLAUDE.md` (repo root) | `.github/copilot-instructions.md` | Both auto-loaded for repo context |
| `~/.claude/CLAUDE.md` (user) | VS Code user settings → Custom Instructions | User-level persistent instructions |
| Session context injection | `@workspace` chat participant | Brings repo structure into context |

**Migration steps:**
1. Copy `CLAUDE.md` content to `.github/copilot-instructions.md`
2. Remove Claude-specific syntax (no special YAML front-matter needed)
3. Add VS Code user instructions in **Settings → Copilot → Custom Instructions**

---

### Slash Commands → Chat Commands

**Claude Code** slash commands (e.g., `/add-dir`, `/compact`, `/model`) control session behaviour and trigger pre-defined operations.

**GitHub Copilot** Chat provides built-in slash commands scoped to different surfaces:

| Claude Command | Copilot Equivalent | Surface |
|----------------|-------------------|---------|
| `/help` | `/help` | Chat |
| `/clear` | `/clear` | Chat |
| (explain code) | `/explain` | Chat / Inline |
| (fix issue) | `/fix` | Inline chat |
| (generate tests) | `/tests` | Chat |
| (add docs) | `/doc` | Chat |
| (scaffold project) | `/new` | Chat |
| (new notebook) | `/newNotebook` | Chat |
| `/model <name>` | Model picker in chat UI | Chat toolbar |
| `/add-dir` | `@workspace` context | Implicit via workspace |

Copilot also has **chat participants** that route queries to specialised agents:

- `@workspace` — understands your full codebase
- `@vscode` — answers VS Code configuration questions
- `@terminal` — helps with shell commands
- `@github` — searches issues, PRs, docs on GitHub.com

---

### Skills → Copilot Extensions

**Claude Skills** are markdown files in `~/.claude/skills/` that teach Claude a reusable capability (e.g., "generate a REST API scaffold").

**GitHub Copilot Extensions** are GitHub Apps that expose capabilities via a webhook. They appear as `@extension-name` in Copilot Chat.

| Claude Skills | Copilot Extensions |
|---------------|--------------------|
| Markdown template files | GitHub App + webhook handler |
| `~/.claude/skills/*.md` | Marketplace listing or private app |
| Invoked by name in prompt | Invoked as `@extension-name` |
| No auth required | Uses GitHub App OAuth |
| Single-user or team | Per-org or public marketplace |

Popular extensions: `@docker`, `@databricks`, `@sentry`, `@azure`, `@stripe`

Building your own: Create a GitHub App, implement the Copilot Extension API spec, deploy a webhook server.

---

### Subagents → Agent Mode & Coding Agent

**Claude Subagents** spawn child Claude processes to handle specialised sub-tasks in parallel, with results merged back into the parent session.

**GitHub Copilot** offers two agentic modes:

| Claude | Copilot | Scope |
|--------|---------|-------|
| Subagent (CLI, local) | **Agent Mode** (VS Code) | Local multi-file autonomous edits |
| Subagent (remote) | **Copilot coding agent** | Cloud-based, triggered via GitHub issues |
| Custom subagent script | `copilot-setup-steps.yml` | Environment bootstrap for coding agent |

**Agent Mode** in VS Code:
- Enable with the agent toggle in Copilot Chat
- Autonomously reads/writes files, runs terminal commands, iterates
- Human-in-the-loop approval for destructive operations

**Copilot coding agent**:
- Assign a GitHub issue to `@copilot`
- Runs in a cloud sandbox, opens a PR with changes
- Customise the environment with `.github/copilot-setup-steps.yml`

---

### MCP → Copilot MCP Support

Both Claude Code and GitHub Copilot implement the **Model Context Protocol** for connecting AI to external tools and data sources.

| Claude MCP Config | Copilot MCP Config |
|-------------------|--------------------|
| `~/.claude/settings.json` → `mcpServers` | `.vscode/mcp.json` |
| `claude_desktop_config.json` | VS Code `settings.json` → `mcp` section |
| `--mcp-config` CLI flag | Workspace-level config auto-loaded |

**Example `.vscode/mcp.json`:**

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "gallery": true
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"]
    }
  }
}
```

The configuration schema is nearly identical — only the file location differs.

---

### Hooks → GitHub Actions

**Claude Hooks** fire shell scripts on session events (pre-tool, post-tool, notification, stop).

**GitHub Copilot** doesn't have runtime hooks, but the closest equivalents are:

| Claude Hook | Copilot / GitHub Equivalent |
|-------------|----------------------------|
| `pre-tool` hook | Pre-commit hook (runs before commit) |
| `post-tool` hook | Post-commit hook or Actions step |
| Session stop hook | PR merge trigger in GitHub Actions |
| Notification hook | GitHub Actions `on: pull_request` event |
| Custom validation | GitHub Actions `on: push` CI checks |

Use Copilot to **generate** your GitHub Actions workflows and pre-commit configurations — it understands workflow syntax and can scaffold entire CI/CD pipelines from a description.

---

### Plugins → VS Code Extensions

**Claude Plugins** bundle capabilities (skills, hooks, slash commands) into a package installed with `/install-github-app` or loaded from `~/.claude/`.

**GitHub Copilot** achieves this via two mechanisms:

| Claude Plugin | Copilot Equivalent |
|---------------|--------------------|
| Plugin YAML manifest | VS Code extension `package.json` |
| `/install-github-app` | VS Code Extensions marketplace |
| `~/.claude/plugins/` | VS Code extension storage |
| Coding agent bootstrap | `copilot-setup-steps.yml` |

`copilot-setup-steps.yml` (at `.github/copilot-setup-steps.yml`) lets you pre-install tools, configure the shell environment, and cache dependencies for the coding agent — fulfilling the "bootstrap a custom environment" role that plugins served in Claude.

---

### Checkpoints → Git + PR Features

**Claude Checkpoints** snapshot the session state so you can revert to a prior point mid-task.

**GitHub Copilot** relies on Git for state management, enhanced with Copilot features:

| Claude Checkpoint | Git / Copilot Equivalent |
|-------------------|--------------------------|
| Create checkpoint | `git commit` (atomic snapshot) |
| List checkpoints | `git log --oneline` |
| Restore checkpoint | `git checkout <sha>` or `git revert` |
| Checkpoint on change | Copilot-suggested commit messages |
| Session context | PR description (Copilot auto-generated) |
| Review changes | Copilot Code Review inline comments |

**Workflow:** Use Copilot's commit message generation (VS Code Source Control panel) to create frequent, descriptive commits — these become your checkpoints.

---

### Advanced Features → Multi-Model & Workspace

**Claude Advanced Features** include extended thinking, background tasks, and model selection.

**GitHub Copilot** equivalents:

| Claude Feature | Copilot Equivalent |
|----------------|--------------------|
| Extended thinking | o3-mini / o1 models (reasoning models) |
| Background tasks | Copilot coding agent (async cloud runs) |
| Model selection (`/model`) | Model picker in Chat (GPT-4.1, Claude 3.5, Gemini) |
| Vision (image input) | Attach image to Copilot Chat |
| Web search | Copilot Chat with `@github` + web search |
| Large-scale refactor | Copilot Workspace (task → plan → PR) |

Available models in Copilot (as of 2025):
- **GPT-4.1** — Best for complex reasoning and long context
- **Claude 3.5 / 3.7 Sonnet** — Strong code generation
- **Gemini 1.5 / 2.0 Pro** — Multimodal, large context window
- **o3-mini** — Fast reasoning tasks

---

### Claude CLI → gh copilot CLI

**Claude CLI** (`claude`) runs AI assistance from the terminal with full session management.

**GitHub Copilot CLI** (`gh copilot`) is a `gh` extension providing AI assistance for shell commands:

| Claude CLI | gh copilot CLI |
|------------|----------------|
| `claude "explain this code"` | `gh copilot explain "git rebase -i HEAD~3"` |
| `claude "write a bash script"` | `gh copilot suggest "compress all png files"` |
| Interactive session | Interactive revision loop |
| `claude --model` | `gh copilot` uses account's default model |
| `/add-dir` to add context | Pass code via stdin or args |

```bash
# Install
gh extension install github/gh-copilot

# Suggest a command
gh copilot suggest "find all files modified in the last 24 hours"

# Explain a command
gh copilot explain "awk '{print $2}' file.txt | sort | uniq -c"

# Useful shell aliases
alias ghcs='gh copilot suggest'
alias ghce='gh copilot explain'
```

---

## Conversion Notes by Module

### Module 01: Slash Commands → Chat Commands
The original module focused on building custom slash command templates. In Copilot, slash commands are built-in and not user-defined; the equivalent customisation is done through **custom instructions** and **prompt crafting**. The new module therefore covers all built-in commands exhaustively plus chat participant routing.

### Module 02: Memory → Custom Instructions
`CLAUDE.md` and `.github/copilot-instructions.md` are structurally identical — both are markdown files read automatically. The new module provides side-by-side migration templates and adds coverage of VS Code user-level instructions, which have no direct Claude equivalent.

### Module 03: Skills → Extensions
Claude Skills are simple markdown files; Copilot Extensions are full GitHub Apps. The new module bridges this complexity gap with a "skillset" extension type (simpler, closer to Claude Skills) as well as full agent extensions.

### Module 04: Subagents → Agent Mode & Coding Agent
The original module covered CLI-based subagent spawning. The new module covers both local agent mode (VS Code) and cloud coding agent (issues-to-PR), which together provide broader capability than Claude Subagents.

### Module 05: MCP → Copilot MCP
This is the closest 1:1 mapping — MCP is an open standard and both tools implement it. The new module focuses on configuration differences and Copilot-specific MCP servers.

### Module 06: Hooks → Actions Integration
Claude Hooks are synchronous runtime callbacks; GitHub Actions are asynchronous event-driven workflows. The new module reframes "automation at coding time" as "automation at CI/CD time" and shows how to use Copilot to generate the automation code itself.

### Module 07: Plugins → Workspace
Claude Plugins bundle multiple capabilities together. The Copilot equivalent is more fragmented (Extensions + VS Code Extensions + setup steps). The new module unifies these under the "Workspace" concept — how Copilot integrates into different development environments.

### Module 08: Checkpoints → Version Control
Claude Checkpoints are session-level snapshots; Git commits are project-level snapshots. The new module covers Git-native checkpoint patterns and Copilot's PR-level features that add AI context to the version history.

### Module 09: Advanced Features
Both tools have similar advanced features. The new module emphasises multi-model selection (unique to Copilot's multi-vendor model support) and Copilot Workspace, which has no direct Claude equivalent.

### Module 10: CLI
The `claude` CLI and `gh copilot` CLI serve different use cases. `claude` is a full coding environment; `gh copilot` is a command-suggestion tool. The new module frames this correctly and shows how to compose `gh copilot` into larger terminal workflows.

---

## New Course Modules

The following modules make up the **GitHub Copilot in a Weekend** course:

| Module | Title | Link |
|--------|-------|------|
| 01 | GitHub Copilot Chat Commands | [copilot-course/01-chat-commands/](copilot-course/01-chat-commands/) |
| 02 | Custom Instructions & Copilot Instructions Files | [copilot-course/02-custom-instructions/](copilot-course/02-custom-instructions/) |
| 03 | GitHub Copilot Extensions | [copilot-course/03-extensions/](copilot-course/03-extensions/) |
| 04 | Copilot Agent Mode & Coding Agent | [copilot-course/04-agent-mode/](copilot-course/04-agent-mode/) |
| 05 | Model Context Protocol (MCP) with GitHub Copilot | [copilot-course/05-mcp/](copilot-course/05-mcp/) |
| 06 | GitHub Actions & Automation Integration | [copilot-course/06-actions-integration/](copilot-course/06-actions-integration/) |
| 07 | Copilot Workspace & VS Code Integration | [copilot-course/07-workspace/](copilot-course/07-workspace/) |
| 08 | Version Control & GitHub Integration | [copilot-course/08-version-control/](copilot-course/08-version-control/) |
| 09 | Advanced GitHub Copilot Features | [copilot-course/09-advanced-features/](copilot-course/09-advanced-features/) |
| 10 | GitHub Copilot CLI Reference | [copilot-course/10-cli/](copilot-course/10-cli/) |

Start at the [course landing page](copilot-course/README.md) →

---

*This guide is part of the **GitHub Copilot in a Weekend** course. Original Claude How To content remains in the numbered module folders (01-10) for reference.*
