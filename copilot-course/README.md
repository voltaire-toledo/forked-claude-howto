# GitHub Copilot in a Weekend

> A practical, hands-on course for developers who want to master GitHub Copilot. Work through all 10 modules over a weekend and go from zero to productive with AI-assisted development.

---

## Course Overview

This course teaches **GitHub Copilot** from first principles through 10 progressive modules. Each module is self-contained, includes copy-paste examples, and maps back to the original Claude How To modules for learners making the transition.

**Prerequisite:** A GitHub account with Copilot access (Individual, Business, or Enterprise) and VS Code with the [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) installed.

---

## Module Index

| # | Title | Key Concepts | Time |
|---|-------|-------------|------|
| [01](01-chat-commands/) | Chat Commands | `/explain`, `/fix`, `/tests`, `@workspace` | 30 min |
| [02](02-custom-instructions/) | Custom Instructions | `.github/copilot-instructions.md`, instruction hierarchy | 30 min |
| [03](03-extensions/) | Extensions | `@extension-name`, skillsets, building extensions | 45 min |
| [04](04-agent-mode/) | Agent Mode & Coding Agent | Autonomous edits, issue-to-PR, setup steps | 60 min |
| [05](05-mcp/) | Model Context Protocol | `.vscode/mcp.json`, MCP servers, auth | 45 min |
| [06](06-actions-integration/) | Actions & Automation | Workflow generation, PR automation, pre-commit | 45 min |
| [07](07-workspace/) | Workspace & IDE Integration | Copilot Workspace, multi-editor support | 30 min |
| [08](08-version-control/) | Version Control | Commit messages, PR descriptions, code review | 30 min |
| [09](09-advanced-features/) | Advanced Features | Multi-model, vision, reasoning models | 45 min |
| [10](10-cli/) | CLI Reference | `gh copilot suggest`, `gh copilot explain` | 20 min |

**Total estimated time:** ~6 hours (one weekend)

---

## How to Navigate the Course

```
Day 1 (Morning):   Modules 01–03  →  Core chat, instructions, extensions
Day 1 (Afternoon): Modules 04–05  →  Agent mode, MCP
Day 2 (Morning):   Modules 06–07  →  Automation, workspace
Day 2 (Afternoon): Modules 08–10  →  Version control, advanced, CLI
```

Each module README contains:
- **Concept explanation** with diagrams
- **Hands-on examples** you can try immediately
- **Copy-paste templates** for real-world use
- **Comparison table** mapping to the equivalent Claude Code concept

---

## Prerequisites

```bash
# 1. GitHub account with Copilot subscription
#    → https://github.com/features/copilot

# 2. VS Code with Copilot extension
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat

# 3. gh CLI (for Module 10)
# macOS
brew install gh
# Linux
sudo apt install gh
# Windows
winget install GitHub.cli

# 4. Authenticate gh
gh auth login
gh extension install github/gh-copilot
```

---

## Comparison: This Course vs Claude How To

| Dimension | Claude How To (original) | Copilot in a Weekend (this course) |
|-----------|--------------------------|-------------------------------------|
| **Primary tool** | Claude Code CLI | GitHub Copilot (VS Code + gh) |
| **Config file** | `CLAUDE.md` | `.github/copilot-instructions.md` |
| **Extensions** | Skill markdown files | GitHub Apps / Copilot Extensions |
| **Automation** | Shell hooks | GitHub Actions |
| **Cloud agent** | Subagents (CLI) | Copilot coding agent (issues) |
| **MCP** | `~/.claude/settings.json` | `.vscode/mcp.json` |
| **CLI** | `claude` | `gh copilot` |
| **Multi-model** | Anthropic family | GPT-4.1, Claude, Gemini, o3 |

See [TRANSITION_GUIDE.md](../TRANSITION_GUIDE.md) for a full concept-by-concept mapping.

---

## Quick Start

If you only have 30 minutes, do this:

1. Open VS Code in any project
2. Press `Ctrl+Shift+I` (or `Cmd+Shift+I` on macOS) to open Copilot Chat
3. Type `/explain` and select some code — Copilot explains it
4. Try `/fix` on a function with a bug
5. Try `/tests` to generate unit tests
6. Create `.github/copilot-instructions.md` with your project's coding standards

You're now using Copilot effectively. Continue with Module 01 for the full picture.

---

## Self-Assessment

After completing the course, run the self-assessment quiz:

```bash
chmod +x ../self-assessment.sh
../self-assessment.sh
```

This covers one question per module with scoring and personalised study recommendations.

---

*Part of the [Claude How To repository](../README.md) — the original Claude Code modules remain in `01-slash-commands/` through `10-cli/` for reference.*
